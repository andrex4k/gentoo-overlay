# Copyright 2026
# Distributed under the terms of the GNU General Public License v2
#
# Compatibility shim for user.eclass.
#
# user.eclass was removed from the Gentoo repository in 2022 (GLEP 81),
# but some vintage ebuilds in this overlay (usbmuxd, firebird, firebird-bin,
# charybdis, yacy) still call enewuser()/enewgroup() from pkg_setup().
# This file implements just those functions on top of useradd/groupadd so
# that the packages keep working.
#
# New ebuilds must not inherit this eclass: depend on the appropriate
# acct-user/* and acct-group/* packages instead.

if [[ -z ${_USER_ECLASS} ]]; then
_USER_ECLASS=1

# @FUNCTION: egetent
# @USAGE: <database> <key>
# @DESCRIPTION:
# Query the system account databases (passwd, group, shadow).
egetent() {
	getent "$1" "$2" 2>/dev/null
}

# @FUNCTION: egethome
# @USAGE: <user>
# @DESCRIPTION:
# Print the home directory of a user.
egethome() {
	getent passwd "$1" 2>/dev/null | cut -d: -f6
}

# @FUNCTION: egetshell
# @USAGE: <user>
# @DESCRIPTION:
# Print the login shell of a user.
egetshell() {
	getent passwd "$1" 2>/dev/null | cut -d: -f7
}

# @FUNCTION: enewgroup
# @USAGE: <group> [gid]
# @DESCRIPTION:
# Create a group if it does not exist yet.  Without a GID a system group is
# allocated (groupadd -r).
enewgroup() {
	local group=$1 gid=$2
	local -a opts=()

	if [[ ${EUID} -ne 0 ]]; then
		ewarn "Insufficient privileges to execute enewgroup"
		return 0
	fi
	[[ -n ${group} ]] || die "enewgroup: no group name given"
	getent group "${group}" >/dev/null && return 0

	if [[ -n ${gid} && ${gid} != -1 ]]; then
		opts+=( -g "${gid}" )
	else
		opts+=( -r )
	fi

	groupadd "${opts[@]}" "${group}" || die "groupadd ${group} failed"
	einfo "Added group ${group} (GID $(getent group "${group}" | cut -d: -f3))"
}

# @FUNCTION: enewuser
# @USAGE: <user> [uid] [shell] [home] [groups] [comment]
# @DESCRIPTION:
# Create a user if it does not exist yet.  "-1" means "pick a default" for
# uid, shell (nologin) and home (/dev/null).  Additional groups are given as
# a comma separated list; the first one becomes the primary group.
enewuser() {
	local user=$1 uid=$2 shell=$3 home=$4 groups=$5 comment=$6
	local -a opts=( -M -N -r )
	local -a garr=()
	local g defgroup= extra=

	if [[ ${EUID} -ne 0 ]]; then
		ewarn "Insufficient privileges to execute enewuser"
		return 0
	fi
	[[ -n ${user} ]] || die "enewuser: no user name given"
	getent passwd "${user}" >/dev/null && return 0

	if [[ -n ${uid} && ${uid} != -1 ]]; then
		opts+=( -u "${uid}" )
	fi

	if [[ -z ${shell} || ${shell} == -1 ]]; then
		opts+=( -s /sbin/nologin )
	else
		[[ -x ${shell} ]] || die "enewuser: shell ${shell} does not exist"
		opts+=( -s "${shell}" )
	fi

	if [[ -z ${home} || ${home} == -1 ]]; then
		home=
		opts+=( -d /dev/null )
	else
		opts+=( -d "${home}" )
	fi

	if [[ -n ${groups} ]]; then
		local IFS=,
		read -r -a garr <<<"${groups}"
		unset IFS
		for g in "${garr[@]}"; do
			getent group "${g}" >/dev/null ||
				die "enewuser: group ${g} does not exist"
			if [[ -z ${defgroup} ]]; then
				defgroup=${g}
			else
				extra+="${extra:+,}${g}"
			fi
		done
		opts+=( -g "${defgroup}" )
		[[ -n ${extra} ]] && opts+=( -G "${extra}" )
	fi

	[[ -n ${comment} ]] && opts+=( -c "${comment}" )

	useradd "${opts[@]}" "${user}" || die "useradd ${user} failed"
	einfo "Added user ${user}"

	if [[ -n ${home} && ! -d ${home} ]]; then
		mkdir -p "${home}" || die "cannot create ${home}"
		chown "${user}:" "${home}" 2>/dev/null || true
		chmod 0755 "${home}"
	fi
}

fi
