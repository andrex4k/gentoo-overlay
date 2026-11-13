#!/bin/bash
# Copyright 2026
# Distributed under the terms of the GNU General Public License v2
#
# Configure CryptoPro CSP.
#
# The vendor RPM packages do their configuration in %post scriptlets: they
# call /opt/cprocsp/sbin/<arch>/cpconfig, which writes
# /etc/opt/cprocsp/config64.ini.  Gentoo prebuilt packages cannot run those
# scriptlets, so this helper performs the same registrations.  It is
# idempotent and is run from pkg_postinst() and from
# `emerge --config app-crypt/cprocsp`.
#
# The per-component registrations live in cprocsp-providers.sh (KC1/KC2
# provider descriptions) and cprocsp-readers.sh (smart card/token drivers),
# both derived from the %post scriptlets of the 5.0.13003 RPM packages.

CP_ROOT=${CP_ROOT:-/opt/cprocsp}
CP_LIBEXEC=${CP_ROOT}/libexec
# Location of the mutable state (keys, stores, temporary files).
CP_VAR=${CP_VAR:-/var/opt/cprocsp}

die() {
	echo "cprocsp-postinst: $*" >&2
	exit 1
}

# --- locate the installed architecture -------------------------------------
# cpconfig is the only binary whose location is not fixed; every other path
# is derived from it (the vendor uses bin|sbin|lib/<arch> for all of them).
CPCONFIG=$(ls -1 "${CP_ROOT}"/sbin/*/cpconfig 2>/dev/null | head -n 1)
[[ -n ${CPCONFIG} ]] || die "cpconfig not found under ${CP_ROOT}/sbin"
CP_SBINDIR=${CPCONFIG%/*}
CP_ARCH=${CP_SBINDIR##*/}
CP_BINDIR=${CP_ROOT}/bin/${CP_ARCH}
CP_LIBDIR=${CP_ROOT}/lib/${CP_ARCH}
[[ -x ${CP_BINDIR}/csptest ]] || die "CryptoPro CSP is not installed completely"

export PATH=${CP_SBINDIR}:${CP_BINDIR}:${PATH}
export NLSPATH=${CP_ROOT}/share/locale/%L/LC_MESSAGES/%N

# Feature switches written by the ebuild (demo license, OS CA import).
CP_DEMO_LICENSE=0
CP_IMPORT_CA_CERTS=0
# shellcheck source=/dev/null
[[ -r ${CP_LIBEXEC}/cprocsp-features.conf ]] && . "${CP_LIBEXEC}/cprocsp-features.conf"

# cpconfig -ini <section> -add <type> <name> <value>
cp_ini() {
	"${CPCONFIG}" -ini "$1" -add "$2" "$3" "$4" >/dev/null 2>&1
}

# cpconfig -hardware ... (reader/random/media registration)
cp_hw() {
	"${CPCONFIG}" -hardware "$@" >/dev/null 2>&1
}

# Register a shared object in \config\apppath when it is installed.
cp_apppath() {
	local soname=$1 lib=$2
	[[ -e ${CP_LIBDIR}/${lib} ]] || return 0
	cp_ini '\config\apppath' string "${soname}" "${CP_LIBDIR}/${lib}"
}

# --- state directories and permissions ------------------------------------
# The vendor installer (and the SysV init script's repair_var) makes these
# world writable: every user keeps containers and stores below them.
mkdir -p "${CP_ROOT}" "${CP_VAR}"
for d in dsrf dsrf/db1 dsrf/db2 keys tmp users users/stores mnt tmpcerts ostmpcerts; do
	mkdir -p "${CP_VAR}/${d}"
done
chmod 1777 "${CP_VAR}/tmp"
chmod 1777 "${CP_VAR}/keys"
chmod 1777 "${CP_VAR}/users"

# --- core libraries (from lsb-cprocsp-rdr and lsb-cprocsp-capilite) -------
cp_apppath libcapi10.so libcapi10.so
cp_apppath librdrfat12.so librdrfat12.so
cp_apppath librdrdsrf.so librdrdsrf.so
cp_apppath libcpui.so libcpui.so
cp_apppath libssp.so libssp.so
cp_apppath libcapi20.so libcapi20.so

# The CSP talks to the system libcurl (used by cryptcp/urlretrieve).
# Prefer the real shared object from ldconfig, as the vendor %post does.
libcurl=$(ldconfig -p 2>/dev/null | awk '$1 ~ /^libcurl.*\.so/ { print $NF; exit }')
if [[ -n ${libcurl} ]]; then
	cp_ini '\config\apppath' string libcurl.so "${libcurl}"
else
	cp_ini '\config\apppath' string libcurl.so libcurl.so.4
fi

# --- random number sources and key media ----------------------------------
cp_hw rndm add CPSD -name 'CPSD RNG' -level 3
cp_ini '\config\Random\CPSD\Default' string '/db1/kis_1' "${CP_VAR}/dsrf/db1/kis_1"
cp_ini '\config\Random\CPSD\Default' string '/db2/kis_1' "${CP_VAR}/dsrf/db2/kis_1"
cp_hw reader add hdimage -name 'HDD key storage'

# --- KC1 / KC2 provider registration --------------------------------------
# shellcheck source=/dev/null
[[ -r ${CP_LIBEXEC}/cprocsp-providers.sh ]] && . "${CP_LIBEXEC}/cprocsp-providers.sh"

# --- capilite: certificate stores -----------------------------------------
cp_ini '\config\parameters' long dynamic_readers 1
cp_ini '\config\parameters' long dynamic_rdr_refresh_ms 1500

if "${CP_BINDIR}/csptest" -keyset -verifycontext >/dev/null 2>&1; then
	# Create the local machine stores used by the browser plugin and CSP.
	"${CP_BINDIR}/certmgr" -list -crl -store mMy >/dev/null 2>&1
	"${CP_BINDIR}/certmgr" -list -crl -store mCryptoProTrustedStore >/dev/null 2>&1
	"${CP_BINDIR}/certmgr" -list -crl -store mClientAuthIssuer >/dev/null 2>&1

	# Convert stores written by older versions to the Windows-compatible
	# format.  Errors are printed, but do not abort the configuration.
	find "${CP_VAR}/users" -name '*.sto' -type f \
		-exec "${CP_BINDIR}/certmgr" -updatestore -crl -file {} \; >/dev/null
	find "${CP_VAR}/users" -name '*.sto' -type f \
		-exec "${CP_BINDIR}/certmgr" -updatestore -cert -file {} \; >/dev/null

	"${CP_BINDIR}/cpinstance" >/dev/null 2>&1
else
	echo "cprocsp-postinst: warning: provider does not work yet," \
		"skipping certificate store setup" >&2
fi

# --- licensing ------------------------------------------------------------
if [[ ${CP_DEMO_LICENSE} == 1 ]]; then
	if ! "${CPCONFIG}" -license -view >/dev/null 2>&1; then
		# Time-limited demo license shipped by the vendor installer
		# (see the %post of lsb-cprocsp-rdr: -use_expired makes it usable
		# even after its validity period).
		"${CPCONFIG}" -license -set 5050N-40030-01BT7-2MA83-QF3T0 -use_expired \
			>/dev/null 2>&1
	fi
fi

# --- GUI dialogs (cprocsp-rdr-gui-gtk) ------------------------------------
if [[ -e ${CP_LIBDIR}/libfgcpui.so ]]; then
	cp_apppath librdrrndmbio_gui_fgtk.so librdrrndmbio_gui_fgtk.so
	cp_ini '\config\apppath' string libxcpui.so "${CP_LIBDIR}/libfgcpui.so"
	cp_ini '\config\apppath' string xcpui_app "${CP_SBINDIR}/xcpui_app"
	cp_ini '\config\Random\Bio_gui' string DLL librdrrndmbio_gui_fgtk.so
	cp_hw rndm add bio_gui -name 'rndm GUI GTK' -level 4
fi

# --- PC/SC smart card readers (cprocsp-rdr-pcsc) --------------------------
if [[ -e ${CP_LIBDIR}/librdrpcsc.so ]]; then
	libpcsclite=$(ldconfig -p 2>/dev/null | awk '$1 ~ /^libpcsclite\.so/ { print $NF; exit }')
	cp_ini '\config\apppath' string libpcsclite.so "${libpcsclite:-libpcsclite.so.1}"

	cp_apppath librdrpcsc.so librdrpcsc.so
	cp_apppath librdrric.so librdrric.so
	cp_ini '\config\KeyDevices\PCSC' string DLL librdrpcsc.so
	cp_ini '\config\KeyDevices\PCSC' long Group 1
	# The section without parameters is required for "dynamic" readers; the
	# "Name" value is added and immediately removed because cpconfig cannot
	# create an empty section.
	cp_ini '\config\KeyDevices\PCSC\PNP PCSC\Default' string Name 'All PC/SC readers'
	"${CPCONFIG}" -ini '\config\KeyDevices\PCSC\PNP PCSC\Default\Name' -delparam \
		>/dev/null 2>&1

	for c in OSCAR OSCAR2 TRUST TRUSTS TRUSTD; do
		cp_ini "\\config\\KeyCarriers\\${c}" string DLL librdrric.so
	done

	cp_hw media add oscar -name 'Oscar'
	cp_hw media configure oscar add hex atr 0000000000000043525950544f5052
	cp_hw media configure oscar add hex mask 00000000000000ffffffffffffffff
	cp_hw media configure oscar add string folders 0B00

	cp_hw media add oscar2 -name 'Oscar CSP 2.0'
	cp_hw media configure oscar2 add hex atr 000000000000004350435350010102
	cp_hw media configure oscar2 add hex mask 00000000000000ffffffffffffffff
	cp_hw media configure oscar2 add string folders 0B00
	for n in 1:60 2:70 4:60 5:70 6:62; do
		cp_hw media configure oscar2 add long "size_${n%%:*}" "${n##*:}"
	done
	cp_hw media add oscar2 -connect KChannel -name 'Channel K'
	cp_hw media configure oscar2 -connect KChannel add hex atr 000000000000004350435350010101
	cp_hw media configure oscar2 -connect KChannel add hex mask 00000000000000ffffffffffffffff
	cp_hw media configure oscar2 -connect KChannel add string folders 0B00
	for n in 1:56 2:36 4:56 5:36 6:62; do
		cp_hw media configure oscar2 -connect KChannel add long "size_${n%%:*}" "${n##*:}"
	done

	cp_hw media add TRUST -name 'Foros (Magistra)'
	cp_hw media configure TRUST add hex atr 3b9e00008031c0654d4700000072f7418107
	cp_hw media configure TRUST add hex mask ffff0000ffffffffffff300000ffffffffff
	cp_hw media configure TRUST add string folders 'A\B\C\D\E\F\G\H'

	cp_hw media add TRUSTS -name 'Foros SocCard'
	cp_hw media configure TRUSTS add hex atr 3b9a00008031c0610072f7418107
	cp_hw media configure TRUSTS add hex mask ffff0000ffffffff30ffffffffff
	cp_hw media configure TRUSTS add string folders 'A\B\C\D'

	cp_hw media add TRUSTD -name 'Foros Debug'
	cp_hw media configure TRUSTD add hex atr 3b9800008031c072f7418107
	cp_hw media configure TRUSTD add hex mask ffff0000ffffffffffffffff
	cp_hw media configure TRUSTD add string folders 'A\B\C\D\E\F\G\H'
fi

# --- CAdES / OCSP / TSP libraries (cprocsp-pki-cades) ---------------------
if [[ -e ${CP_LIBDIR}/libcades.so ]]; then
	cp_ini '\config\apppath' string libcades.so "${CP_LIBDIR}/libcades.so.2"
	cp_ini '\config\apppath' string libpkivalidator.so "${CP_LIBDIR}/libpkivalidator.so.2"
	cp_ini '\config\apppath' string librevprov.so "${CP_LIBDIR}/librevprov.so.2"

	cp_ini '\config\policy\OIDs' string '{A4CC781E-04E9-425C-AAFD-1D74DA8DFAF6}' \
		'libpkivalidator.so CertDllVerifyOCSPSigningCertificateChainPolicy'
	cp_ini '\config\policy\OIDs' string '{AF74EE92-A059-492F-9B4B-EAD239B22A1B}' \
		'libpkivalidator.so CertDllVerifyTimestampSigningCertificateChainPolicy'
	cp_ini '\config\policy\OIDs' string '{B52FF66F-13A5-402C-B958-A3A6B5300FB6}' \
		'libpkivalidator.so CertDllVerifySignatureCertificateChainPolicy'
	cp_ini '\config\policy\OIDs' string '5' 'libpkivalidator.so BasicConstraintsImpl'
	cp_ini '\cryptography\OID\EncodingType 1\CertDllVerifyRevocation\DEFAULT' \
		string DLL librevprov.so

	if [[ ${CP_DEMO_LICENSE} == 1 ]]; then
		# Demo licenses for the OCSP/TSP utilities, as in the vendor %post.
		if "${CP_BINDIR}/ocsputil" license 2>&1 | grep -q 0x8007064A; then
			"${CP_BINDIR}/ocsputil" license -s 0A202-U0030-00ECW-RRLMF-UU2WK \
				>/dev/null 2>&1
		fi
		if "${CP_BINDIR}/tsputil" license 2>&1 | grep -q 0x8007064A; then
			"${CP_BINDIR}/tsputil" license -s TA200-G0030-00ECW-RRLNE-BTDVV \
				>/dev/null 2>&1
		fi
	fi
fi

# Browser native messaging host library (cprocsp-pki-plugin).
if [[ -e ${CP_LIBDIR}/libnpcades.so.2 ]]; then
	cp_ini '\config\apppath' string libnpcades.so "${CP_LIBDIR}/libnpcades.so.2"
fi

# --- smart card and token drivers -----------------------------------------
# shellcheck source=/dev/null
[[ -r ${CP_LIBEXEC}/cprocsp-readers.sh ]] && . "${CP_LIBEXEC}/cprocsp-readers.sh"

# --- CA certificates ------------------------------------------------------
# Root and intermediate certificates shipped by lsb-cprocsp-ca-certs are
# unpacked into /var/opt/cprocsp/tmpcerts and have to be imported into the
# provider stores.  certmgr needs a working provider for that.
if [[ -x ${CP_BINDIR}/certmgr ]] &&
	"${CP_BINDIR}/csptest" -keyset -verifycontext >/dev/null 2>&1; then
	for store in root:mroot ca:mca; do
		dir=${CP_VAR}/tmpcerts/${store%%:*}
		[[ -d ${dir} ]] || continue
		while IFS= read -r -d '' cert; do
			"${CP_BINDIR}/certmgr" -install -store "${store##*:}" -file "${cert}" \
				>/dev/null 2>&1
		done < <(find "${dir}" -maxdepth 1 -type f -name '*.cer' -print0)
	done
fi

# Import the OS trust store on request (lsb-cprocsp-import-ca-certs).
if [[ ${CP_IMPORT_CA_CERTS} == 1 && -x ${CP_BINDIR}/cryptcp ]]; then
	cert_bundle=
	for f in /etc/ssl/certs/ca-certificates.crt /etc/ssl/cert.pem \
		/etc/pki/tls/certs/ca-bundle.crt; do
		[[ -f ${f} ]] && cert_bundle=${f} && break
	done
	if [[ -n ${cert_bundle} ]]; then
		tmpdir=$(mktemp -d "${CP_VAR}/ostmpcerts.XXXXXX") || tmpdir=
		if [[ -n ${tmpdir} ]]; then
			csplit -s -f "${tmpdir}/cert" -n 3 "${cert_bundle}" \
				'/-----BEGIN CERTIFICATE-----/' '{*}' || true
			rm -f "${tmpdir}/cert000"
			find "${tmpdir}" -type f -name 'cert*' -print0 |
				xargs -0 -r -n 100 "${CP_BINDIR}/cryptcp" -copycert -silent \
					-nochain -dmroot >/dev/null 2>&1
			rm -rf "${tmpdir}"
		fi
	fi
fi

# Sanity check: the default provider must now be visible in the config.
if [[ -e ${CP_LIBDIR}/libcsp.so ]]; then
	"${CPCONFIG}" -ini '\cryptography\Defaults\Provider\Crypto-Pro GOST R 34.10-2012 KC1 CSP' \
		-view >/dev/null 2>&1 || {
		echo "cprocsp-postinst: provider registration failed" >&2
		exit 1
	}
elif [[ -e ${CP_LIBDIR}/libcspr.so ]]; then
	"${CPCONFIG}" -ini '\cryptography\Defaults\Provider\Crypto-Pro GOST R 34.10-2012 KC2 CSP' \
		-view >/dev/null 2>&1 || {
		echo "cprocsp-postinst: provider registration failed" >&2
		exit 1
	}
fi

if [[ -e ${CP_LIBDIR}/libcspr.so ]] && command -v pgrep >/dev/null 2>&1 &&
	! pgrep -x cryptsrv >/dev/null 2>&1; then
	echo "cprocsp-postinst: note: KC2 needs the cryptsrv service," >&2
	echo "  start it with 'rc-service cprocsp start' (or systemctl)" >&2
	echo "  and re-run 'emerge --config app-crypt/cprocsp'" >&2
fi

echo "cprocsp-postinst: configuration of ${CP_ARCH} is complete"
exit 0
