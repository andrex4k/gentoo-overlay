# Copyright 2026
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit systemd toolchain-funcs udev xdg

DESCRIPTION="CryptoPro CSP - GOST R 34.10/34.11 cryptographic service provider"
HOMEPAGE="https://cryptopro.ru/products/csp"

# Proprietary, redistribution of the distfiles is not allowed.
LICENSE="Crypto-Pro"
SLOT="0"
KEYWORDS="~amd64"
# Upstream also ships linux-x86, linux-armhf and linux-arm64 tarballs.
# They are untested here; add ~x86/~arm/~arm64 after verifying the archive.
#KEYWORDS="~amd64 ~x86 ~arm ~arm64"

# The tarballs are only available after registration and must not be
# redistributed, so nothing can be fetched or mirrored automatically.
SRC_URI="
	amd64? ( linux-amd64.tgz )
	x86? ( linux-ia32.tgz )
	arm? ( linux-armhf.tgz )
	arm64? ( linux-arm64.tgz )
"

IUSE="
	+kc1 kc2
	+cades
	+cptools
	+demo-license
	devel
	+gui
	import-ca-certs
	+pkcs11
	rcrypt
	stunnel
	readers_accord
	readers_accord_ccid
	readers_ancud
	+readers_cloud
	+readers_cpfkc
	readers_crypton
	+readers_cryptoki
	+readers_edoc
	+readers_emv
	readers_esmart
	+readers_infocrypt
	+readers_inpaspot
	+readers_jacarta
	+readers_kst
	readers_maxim
	+readers_mskey
	+readers_novacard
	+readers_pcsc
	readers_relay
	+readers_rosan
	+readers_rutoken
	+readers_rustoken
	readers_sobol
	readers_vityaz
"

# Exactly one provider implementation; KC2 is a client/server provider and
# is only needed for HSM/CryptoPro-specific setups.
REQUIRED_USE="
	^^ ( kc1 kc2 )
	cades? ( gui )
	readers_accord_ccid? ( readers_pcsc )
	readers_cpfkc? ( readers_pcsc )
	readers_edoc? ( readers_pcsc )
	readers_emv? ( readers_pcsc )
	readers_esmart? ( readers_pcsc )
	readers_infocrypt? ( readers_pcsc )
	readers_inpaspot? ( readers_pcsc )
	readers_jacarta? ( readers_pcsc )
	readers_kst? ( readers_pcsc )
	readers_mskey? ( readers_pcsc )
	readers_novacard? ( readers_pcsc )
	readers_rosan? ( readers_pcsc )
	readers_rutoken? ( readers_pcsc )
	readers_rustoken? ( readers_pcsc )
"

RESTRICT="bindist fetch mirror strip"

BDEPEND="app-arch/libarchive"

RDEPEND="
	cades? ( dev-libs/libxml2 )
	cptools? ( x11-libs/gtk+:3 )
	gui? ( x11-libs/gtk+:3 )
	readers_pcsc? (
		app-crypt/ccid
		sys-apps/pcsc-lite
	)
	readers_rutoken? ( dev-libs/libusb-compat )
	stunnel? ( sys-libs/pam )
	sys-libs/zlib
"

# Prebuilt, digitally signed binaries.  They must not be stripped: the
# vendor integrity lists in /opt/cprocsp/lib/hashes are checked by cpverify.
# Every binary carries RPATH=/opt/cprocsp/lib/<arch>, which is the vendor's
# way of finding the provider libraries.
QA_PREBUILT="opt/cprocsp/* usr/lib*/pcsc/drivers/*"
QA_FLAGS_IGNORED="opt/cprocsp/* usr/lib*/pcsc/drivers/*"
QA_SONAME="opt/cprocsp/*"
QA_DT_RPATH="opt/cprocsp/*"

S="${WORKDIR}/${P}"

# Upstream directory name inside the tarball ("linux-<arch>").
_cprocsp_vendor_arch() {
	case ${ARCH} in
		amd64) echo amd64 ;;
		x86) echo ia32 ;;
		arm) echo armhf ;;
		arm64) echo arm64 ;;
		*) die "unsupported architecture: ${ARCH}" ;;
	esac
}

# Print the RPM file for a package name, matching the exact package name
# (a plain "find -name '${name}*'" also matches every cprocsp-rdr-* package
# when looking for lsb-cprocsp-rdr).
_cprocsp_rpm() {
	local dir=$1 pkg=$2 f base found=

	for f in "${dir}/${pkg}"-*.rpm "${dir}/${pkg}"_*.rpm; do
		[[ -f ${f} ]] || continue
		base=${f##*/}
		case ${base} in
			"${pkg}"-64-*|"${pkg}"-[0-9]*|"${pkg}"_*) ;;
			*) continue ;;
		esac
		if [[ -n ${found} ]]; then
			eerror "ambiguous RPM for ${pkg}: ${found##*/}, ${base}"
			return 1
		fi
		found=${f}
	done

	if [[ -z ${found} ]]; then
		eerror "RPM for ${pkg} was not found in ${dir}"
		return 1
	fi
	printf '%s\n' "${found}"
}

src_unpack() {
	local tarball=${DISTDIR}/${A}
	local vendor_dir=${S}/vendor
	local image_dir=${S}/image
	local vdir rpm f
	local -a pkgs=(
		# Core, always installed by the vendor installer as well.
		lsb-cprocsp-base
		lsb-cprocsp-rdr
		lsb-cprocsp-capilite
		lsb-cprocsp-ca-certs
		cprocsp-curl
	)
	local -a rpms=()

	[[ -f ${tarball} ]] || die "${A} is missing from DISTDIR (see pkg_nofetch)"
	mkdir -p "${vendor_dir}" "${image_dir}" || die

	einfo "Unpacking ${A}"
	bsdtar -xf "${tarball}" -C "${vendor_dir}" || die "cannot unpack ${A}"

	vdir=$(find "${vendor_dir}" -mindepth 1 -maxdepth 1 -type d -name 'linux-*' -print -quit)
	[[ -n ${vdir} ]] || die "unexpected layout of ${A}"

	use kc1            && pkgs+=( lsb-cprocsp-kc1 )
	use kc2            && pkgs+=( lsb-cprocsp-kc2 )
	use pkcs11         && pkgs+=( lsb-cprocsp-pkcs11 )
	use import-ca-certs && pkgs+=( lsb-cprocsp-import-ca-certs )
	use rcrypt         && pkgs+=( lsb-cprocsp-rcrypt )
	use devel          && pkgs+=( lsb-cprocsp-devel )
	use gui            && pkgs+=( cprocsp-rdr-gui-gtk )
	use cptools        && pkgs+=( cprocsp-cptools-gtk )
	use cades          && pkgs+=( cprocsp-pki-cades cprocsp-pki-plugin )
	use stunnel        && pkgs+=( cprocsp-stunnel )

	use readers_pcsc        && pkgs+=( cprocsp-rdr-pcsc )
	use readers_emv         && pkgs+=( cprocsp-rdr-emv )
	use readers_inpaspot    && pkgs+=( cprocsp-rdr-inpaspot )
	use readers_kst         && pkgs+=( cprocsp-rdr-kst )
	use readers_mskey       && pkgs+=( cprocsp-rdr-mskey )
	use readers_novacard    && pkgs+=( cprocsp-rdr-novacard )
	use readers_edoc        && pkgs+=( cprocsp-rdr-edoc )
	use readers_rutoken     && pkgs+=( cprocsp-rdr-rutoken ifd-rutokens )
	use readers_jacarta     && pkgs+=( cprocsp-rdr-jacarta )
	use readers_cloud       && pkgs+=( cprocsp-rdr-cloud )
	use readers_cpfkc       && pkgs+=( cprocsp-rdr-cpfkc )
	use readers_infocrypt   && pkgs+=( cprocsp-rdr-infocrypt )
	use readers_rosan       && pkgs+=( cprocsp-rdr-rosan )
	use readers_cryptoki    && pkgs+=( cprocsp-rdr-cryptoki )
	use readers_rustoken    && pkgs+=( cprocsp-rdr-rustoken )
	use readers_esmart      && pkgs+=( cprocsp-rdr-esmart )
	use readers_relay       && pkgs+=( cprocsp-rdr-relay )
	use readers_accord      && pkgs+=( lsb-cprocsp-rdr-accord )
	use readers_accord_ccid && pkgs+=( lsb-cprocsp-rdr-accord-ccid )
	use readers_ancud       && pkgs+=( lsb-cprocsp-rdr-ancud )
	use readers_crypton     && pkgs+=( lsb-cprocsp-rdr-crypton )
	use readers_maxim       && pkgs+=( lsb-cprocsp-rdr-maxim )
	use readers_sobol       && pkgs+=( lsb-cprocsp-rdr-sobol )
	use readers_vityaz      && pkgs+=( lsb-cprocsp-rdr-vityaz )

	for rpm in "${pkgs[@]}"; do
		if ! f=$(_cprocsp_rpm "${vdir}" "${rpm}"); then
			die "package ${rpm} is not provided by ${A}"
		fi
		rpms+=( "${f}" )
	done

	for rpm in "${rpms[@]}"; do
		einfo "  extracting ${rpm##*/}"
		bsdtar -xf "${rpm}" -C "${image_dir}" || die "cannot extract ${rpm##*/}"
	done
}

src_install() {
	local image_dir=${S}/image
	local pcsc_dir

	[[ -d ${image_dir} ]] || die "nothing to install; run src_unpack first"

	# The whole vendor tree is prebuilt; copy it as-is so that modes,
	# symlinks and mtimes survive (cpverify checks file contents only, but
	# the provider expects its layout to be intact).
	cp -a "${image_dir}"/. "${ED}"/ || die
	if [[ ${EUID} -eq 0 ]]; then
		chown -R root:root "${ED}" || die
	fi

	# The vendor SysV script is replaced by an OpenRC service: it relies on
	# LSB/RedHat init helpers which do not exist on Gentoo.
	rm -f "${ED}"/etc/init.d/cprocsp || die
	rmdir "${ED}"/etc/init.d 2>/dev/null || true

	# udev rules belong to /usr/lib/udev, not to /etc/udev.
	if use readers_rutoken; then
		udev_dorules "${image_dir}"/etc/udev/rules.d/95-rutokens.rules
	fi
	rm -rf "${ED}"/etc/udev || die

	# LSB loader from cprocsp-compat-*, no binary actually needs it.
	rm -f "${ED}"/lib*/ld-lsb-*.so.* || die

	# Use the same MIME database layout as the rest of the system.
	if use cptools; then
		insinto /usr/share/mime/packages
		doins "${image_dir}"/opt/cprocsp/share/mime/cryptopro-types.xml
		rm -f "${ED}"/opt/cprocsp/share/mime/cryptopro-types.xml || die
	fi

	# pcsc-lite only looks into /usr/$(get_libdir)/pcsc/drivers.
	for pcsc_dir in "${ED}"/usr/lib*/pcsc; do
		[[ -d ${pcsc_dir} ]] || continue
		if [[ ${pcsc_dir} != "${ED}/usr/$(get_libdir)/pcsc" ]]; then
			dodir "/usr/$(get_libdir)"
			mv "${pcsc_dir}" "${ED}/usr/$(get_libdir)/pcsc" || die
		fi
	done

	# Vendor helper scripts (cpconfig registration, service control).
	exeinto /opt/cprocsp/libexec
	doexe "${FILESDIR}"/cprocsp-postinst.sh
	doexe "${FILESDIR}"/cprocsp-services.sh
	insinto /opt/cprocsp/libexec
	doins "${FILESDIR}"/cprocsp-providers.sh
	doins "${FILESDIR}"/cprocsp-readers.sh

	# The upstream %post of cprocsp-rdr-pcsc creates these symlinks; keep
	# them in the package instead of letting a scriptlet create unowned
	# files.
	dosym ../../../../opt/cprocsp/share/bash-completion/completions/certmgr \
		/usr/share/bash-completion/completions/certmgr
	dosym ../../../../opt/cprocsp/share/man/man8/certmgr.8 \
		/usr/share/man/man8/certmgr.8
	dosym ../../../../opt/cprocsp/share/man/man8/csptest.8 \
		/usr/share/man/man8/csptest.8
	# catgets uses both spellings of the UTF-8 locale name.
	dosym ru_RU.utf8 /opt/cprocsp/share/locale/ru_RU.UTF-8

	newinitd "${FILESDIR}"/cprocsp-5.0.13003.initd cprocsp
	systemd_newunit "${FILESDIR}"/cprocsp-5.0.13003.service cprocsp.service

	cat > "${T}"/cprocsp-features.conf <<-EOF || die
		# Generated by the ebuild; read by cprocsp-postinst.sh.
		CP_DEMO_LICENSE=$(usex demo-license 1 0)
		CP_IMPORT_CA_CERTS=$(usex import-ca-certs 1 0)
	EOF
	insinto /opt/cprocsp/libexec
	doins "${T}"/cprocsp-features.conf

	# The vendor state directories are empty, and EAPI 8 strips empty
	# directories from the image; keepdir is needed for them to exist after
	# the merge (before pkg_postinst has run for the first time).
	keepdir /var/opt/cprocsp/dsrf
	keepdir /var/opt/cprocsp/dsrf/db1
	keepdir /var/opt/cprocsp/dsrf/db2
	keepdir /var/opt/cprocsp/keys
	keepdir /var/opt/cprocsp/lmk
	keepdir /var/opt/cprocsp/tmp
	keepdir /var/opt/cprocsp/users/stores

	# They must stay writable for the CSP daemons and for every user's key
	# containers.
	fperms 1777 /var/opt/cprocsp/tmp
	fperms 1777 /var/opt/cprocsp/keys
	fperms 1777 /var/opt/cprocsp/users
}

pkg_nofetch() {
	local v=$(ver_cut 1-2)
	local url="https://cryptopro.ru/sites/default/files/private/csp/${v//.}/$(ver_cut 3)/${A}"

	einfo "The CryptoPro CSP distribution cannot be downloaded automatically."
	einfo "Open this URL in a browser (registration/login is required):"
	einfo "  ${url}"
	einfo ""
	einfo "Then save the downloaded archive as:"
	einfo "  ${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}/${A}"
}

pkg_config() {
	if [[ ${ROOT} != / ]]; then
		ewarn "cpconfig can only configure the running system; skipping."
		return
	fi
	einfo "Re-running CryptoPro CSP configuration"
	/opt/cprocsp/libexec/cprocsp-postinst.sh || ewarn "Configuration reported errors"
}

pkg_postinst() {
	local cpbindir

	if [[ ${ROOT} != / ]]; then
		ewarn "Skipping cpconfig setup: it can only configure the running system."
		return
	fi

	if use cptools; then
		xdg_desktop_database_update
		xdg_mimeinfo_database_update
	fi
	use readers_rutoken && udev_reload

	ebegin "Configuring CryptoPro CSP (cpconfig)"
	/opt/cprocsp/libexec/cprocsp-postinst.sh
	eend $? "cpconfig reported errors; check 'emerge --config ${CATEGORY}/${PN}'"
	# The helper is not fatal: a broken provider still leaves the files in
	# place so that the user can run 'emerge --config' after fixing them.

	if use demo-license; then
		ewarn "A time-limited CryptoPro demo license was installed."
		ewarn "Replace it with your commercial license:"
		ewarn "  /opt/cprocsp/sbin/*/cpconfig -license -set <serial>"
	fi

	cpbindir=$(ls -d /opt/cprocsp/bin/* 2>/dev/null | head -n 1)
	elog "CryptoPro CSP is installed under /opt/cprocsp; its tools are not in"
	elog "PATH on purpose (a patched 'curl' and 'certmgr' would shadow the"
	elog "system ones).  Use absolute paths or add this to your shell:"
	elog "  export PATH=\"${cpbindir}:/opt/cprocsp/sbin/${cpbindir##*/}:\${PATH}\""
	elog ""
	elog "To import certificates from a token as a user (not root):"
	elog "  /opt/cprocsp/bin/*/csptestf -absorb -certs -autoprov"
	elog ""
	elog "If the provider stops working after an upgrade, remove"
	elog "/etc/opt/cprocsp/config64.ini and run"
	elog "  emerge --config ${CATEGORY}/${PN}"
}

pkg_postrm() {
	use readers_rutoken && udev_reload
}

pkg_prerm() {
	if [[ ${ROOT} == / && -x /opt/cprocsp/libexec/cprocsp-services.sh ]]; then
		/opt/cprocsp/libexec/cprocsp-services.sh stop
	fi
}
