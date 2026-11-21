#!/bin/bash
# Copyright 2026
# Distributed under the terms of the GNU General Public License v2
#
# Start, stop and query the CryptoPro CSP daemons.
#
# The vendor SysV script (/etc/init.d/cprocsp in lsb-cprocsp-base) relies on
# LSB or RedHat init helpers and cannot run on Gentoo.  The only thing it
# really does is start every executable listed in
# \config\services\<name>\StartService; this script does the same with
# OpenRC's start-stop-daemon (and a plain setsid fallback for systemd).
#
# With KC1 (the default provider) no services are registered, so start/stop
# are no-ops until KC2 or an HSM package is installed.

set -u

CP_ROOT=${CP_ROOT:-/opt/cprocsp}
RUNDIR=${RUNDIR:-/run}

CPCONFIG=$(ls -1 "${CP_ROOT}"/sbin/*/cpconfig 2>/dev/null | head -n 1)
if [[ -z ${CPCONFIG} ]]; then
	case "${1:-}" in
		stop|status) exit 0 ;;
	esac
	echo "cprocsp-services: cpconfig not found under ${CP_ROOT}/sbin" >&2
	exit 1
fi
CP_SBINDIR=${CPCONFIG%/*}

mkdir -p "${RUNDIR}" 2>/dev/null || true

service_names() {
	"${CPCONFIG}" -ini '\config\services' -enum section 2>/dev/null
}

service_exe() {
	"${CPCONFIG}" -ini "\\config\\services\\$1\\StartService" -view 2>/dev/null
}

pidfile_of() {
	printf '%s/cprocsp-%s.pid\n' "${RUNDIR}" "$1"
}

# Is a process with this name running?  The daemons may fork and detach, so
# a stale pid file alone does not mean that the service is down.
is_running() {
	local name=${1##*/}
	command -v pgrep >/dev/null 2>&1 && pgrep -x "${name}" >/dev/null 2>&1
}

start_service() {
	local svc=$1 exe=$2 pidfile
	pidfile=$(pidfile_of "${svc}")

	if [[ ! -x ${CP_SBINDIR}/${exe} ]]; then
		echo "cprocsp-services: ${CP_SBINDIR}/${exe} is not executable" >&2
		return 1
	fi

	if is_running "${exe}"; then
		echo " * ${exe} is already running"
		return 0
	fi

	if command -v start-stop-daemon >/dev/null 2>&1; then
		if ! start-stop-daemon --start --quiet --background --make-pidfile \
			--pidfile "${pidfile}" --exec "${CP_SBINDIR}/${exe}" --; then
			echo "cprocsp-services: failed to start ${exe}" >&2
			return 1
		fi
	elif command -v setsid >/dev/null 2>&1; then
		setsid "${CP_SBINDIR}/${exe}" </dev/null >/dev/null 2>&1 &
		echo $! > "${pidfile}"
	else
		"${CP_SBINDIR}/${exe}" </dev/null >/dev/null 2>&1 &
		echo $! > "${pidfile}"
	fi

	# Give the daemon a moment to come up (it may still be forking).
	local i
	for ((i = 0; i < 10; i++)); do
		is_running "${exe}" && break
		sleep 0.2
	done
	if ! is_running "${exe}"; then
		echo "cprocsp-services: ${exe} did not start" >&2
		rm -f "${pidfile}"
		return 1
	fi
	echo " * Starting ${exe}"
}

stop_service() {
	local svc=$1 exe=$2 pidfile pid i
	pidfile=$(pidfile_of "${svc}")

	if [[ -f ${pidfile} ]]; then
		pid=$(cat "${pidfile}" 2>/dev/null || true)
		if [[ -n ${pid} ]] && kill -0 "${pid}" 2>/dev/null; then
			kill -TERM "${pid}" 2>/dev/null
			for ((i = 0; i < 30; i++)); do
				kill -0 "${pid}" 2>/dev/null || break
				sleep 1
			done
			kill -KILL "${pid}" 2>/dev/null
			echo " * Stopping ${exe}"
		fi
		rm -f "${pidfile}"
	fi

	# cryptsrv and friends may daemonise themselves, so the pid file is not
	# always authoritative.
	if command -v pkill >/dev/null 2>&1; then
		if pkill -TERM -x "${exe}" 2>/dev/null; then
			echo " * Stopping ${exe}"
			for ((i = 0; i < 30; i++)); do
				is_running "${exe}" || break
				sleep 1
			done
			is_running "${exe}" && pkill -KILL -x "${exe}" 2>/dev/null
		fi
	fi
	return 0
}

do_start() {
	local svc exe found=0
	for svc in $(service_names); do
		exe=$(service_exe "${svc}")
		[[ -n ${exe} ]] || continue
		found=1
		start_service "${svc}" "${exe}" || return 1
	done
	[[ ${found} -eq 1 ]] || echo " * No CryptoPro CSP services are registered"
	return 0
}

do_stop() {
	local svc exe
	for svc in $(service_names); do
		exe=$(service_exe "${svc}")
		[[ -n ${exe} ]] || continue
		stop_service "${svc}" "${exe}"
	done
	return 0
}

do_status() {
	local svc exe pidfile pid rc=0 found=0
	for svc in $(service_names); do
		exe=$(service_exe "${svc}")
		[[ -n ${exe} ]] || continue
		found=1
		pidfile=$(pidfile_of "${svc}")
		pid=$(cat "${pidfile}" 2>/dev/null || true)
		if is_running "${exe}"; then
			echo " * ${exe} is running${pid:+ (pid ${pid})}"
		else
			echo " * ${exe} is stopped"
			rc=3
		fi
	done
	[[ ${found} -eq 1 ]] || echo " * No CryptoPro CSP services are registered"
	return ${rc}
}

case "${1:-}" in
	start) do_start ;;
	stop) do_stop ;;
	restart) do_stop; do_start ;;
	status) do_status ;;
	*)
		echo "Usage: $0 {start|stop|restart|status}" >&2
		exit 2
		;;
esac
