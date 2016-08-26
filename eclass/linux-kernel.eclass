#   |
# .-"-.
# |  ___|
# | (.\/.)  _ BITE MY SHINY METAL ASS!
# |  ,,,'  /
# | '###
# '----'
#
# @ECLASS: linux-kernel.eclass
# @MAINTAINER: Igor Savlook <igorsavlook@gmail.com>
# @BLURB: Eclass for sys-kernel/linux{,-headers} package
# @DESCRIPTION: Simplest and clean version of kernel-2.eclass from
#   official gentoo repository for install stable version of linux
#   kernel and headers.
#
# Hmmm, we can install kernel and headers by one ebuild but many packages
# depend on sys-kernel/linux-headers, eeeeh :(.
#
# ETYPE avalible options:
#   headers - install linux kernel headers only; used by sys-kernel/linux-headers
#   kernel  - install linux kernel, also install headers in /lib/modules/KVER/build
#             for build external modules; used by sys-kernel/linux

case ${EAPI} in
	0|1|2|3|4|5) die "EAPI=${EAPI} not supported"
esac

inherit eutils toolchain-funcs multilib versionator

[[ ${ETYPE} == kernel ]] && inherit savedconfig

EXPORT_FUNCTIONS src_prepare src_configure src_compile src_install pkg_postinst

KMAINVER=$(get_version_component_range 1)
KAPIVER=$(get_version_component_range 1-2)

# If kernel do not have patch version just download full tarball.
# Otherwise download full main tarball and apply patches.
if [[ $(get_version_component_count) -lt "3" ]]
then
	MY_PV="${PV}.0"
	MY_SRC_URI="mirror://kernel/linux/kernel/v${KMAINVER}.x/linux-${PV}.tar.xz"
else
	MY_PV="${PV}"
	MY_SRC_URI="
		mirror://kernel/linux/kernel/v${KMAINVER}.x/linux-$(get_version_component_range 1-2).tar.xz
		mirror://kernel/linux/kernel/v${KMAINVER}.x/patch-${PV}.xz -> linux-patch-${PV}.xz
	"
fi

if [[ ${ETYPE} == headers ]]; then
	DESCRIPTION="Linux kernel headers"
	SLOT="0"
elif [[ ${ETYPE} == "kernel" ]]; then
	DESCRIPTION="Linux kernel"
	SLOT="${PV}"
else
	die "Not selected ETYPE; possible headers or kernel"
fi

HOMEPAGE="http://www.kernel.org/"
SRC_URI="${MY_SRC_URI}"

LICENSE="GPL-2 freedist"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

IUSE=""

RESTRICT="binchecks strip"

DEPEND="
	app-arch/xz-utils

	dev-lang/perl
"

if [[ ${ETYPE} == kernel ]]; then
	IUSE+="dracut +firmware +headers +mheaders symlink"

	RDEPEND="
		dracut? ( sys-kernel/dracut )

		firmware? ( sys-kernel/linux-firmware )

		headers? ( =sys-kernel/linux-headers-${KAPIVER} )

		mheaders? ( app-admin/eselect-linux )
	"

	DEPEND+="${RDEPEND}
		app-text/xmlto

		sys-apps/kmod

		sys-devel/bc
		>=sys-devel/gcc-4.9.3
	"
fi

S="${WORKDIR}/linux-$(get_version_component_range 1-2)"

# Added by Daniel Ostrow <dostrow@gentoo.org>
# This is an ugly hack to get around an issue with a 32-bit userland on ppc64.
# I will remove it when I come up with something more reasonable.
[[ ${PROFILE_ARCH} == "ppc64" ]] && CHOST="powerpc64-${CHOST#*-}"

export CTARGET=${CTARGET:-${CHOST}}
if [[ ${CTARGET} == ${CHOST} && ${CATEGORY/cross-} != ${CATEGORY} ]]; then
	export CTARGET=${CATEGORY/cross-}
fi

unset KBUILD_OUTPUT

KMDIR="/lib/modules/${MY_PV}"

###############################################################################
# Helper functions
###############################################################################

headers_destdir() {
	[[ ${CTARGET} == ${CHOST} ]] \
		&& echo /usr/include \
		|| echo /usr/${CTARGET}/usr/include
}

env_setup_xmakeopts() {
	# Kernel ARCH != portage ARCH
	export KARCH=$(tc-arch-kernel)

	# When cross-compiling, we need to set the ARCH/CROSS_COMPILE
	# variables properly or bad things happen!
	xmakeopts="ARCH=${KARCH}"
	if [[ ${CTARGET} != ${CHOST} ]] ; then
		xmakeopts="${xmakeopts} CROSS_COMPILE=${CTARGET}-"
	elif type -p ${CHOST}-ar > /dev/null ; then
		xmakeopts="${xmakeopts} CROSS_COMPILE=${CHOST}-"
	fi
	export xmakeopts
}

# Delete and after create symlink.
symlink_rm_ln() {
	local trg="${1}"
	local lnk="${2}"

	rm -f "${lnk}" || die "failed delete ${lnk} symlink"
	ln -s "${trg}" "${lnk}" || die "failed create ${lnk} symlink"
}

###############################################################################
# Headers helper functions
###############################################################################

headers_src_prepare() {
	env_setup_xmakeopts

	make ${xmakeopts} mrproper || die "mrproper failed"
}

headers_src_compile() {
	env_setup_xmakeopts

	make ${xmakeopts} headers_check || die "headers_check failed"
}

headers_src_install() {
	env_setup_xmakeopts

	local ddir=$(headers_destdir)

	# Fix silly permissions in tarball.
	chown -R 0:0 * >& /dev/null
	chmod -R a+r-w+X,u+w *

	make ${xmakeopts} INSTALL_HDR_PATH="${ED}/${ddir}/.." headers_install \
		|| die "headers_install failed"

	# Let other packages install some of these headers.
	# glibc / uclibc / etc ...
	rm -rf "${ED}/${ddir}/scsi" || die "remove scsi headers failed"

	# Remove empty directory.
	rm -rf "${ED}/${ddir}/uapi" || die "remove empty uapi directory failed"

	# Clean-up unnecessary files generated during install
	find ${ED} \( -name .install -o -name ..install.cmd \) -delete
}

###############################################################################
# Kernel helper functions
###############################################################################

kernel_src_prepare() {
	env_setup_xmakeopts

	if [[ $(get_version_component_count) -gt "2" ]]
	then
		epatch "${WORKDIR}/linux-patch-${PV}"
	fi

	# Don't run depmod on 'make install'. We'll do this ourselves.
	sed -i "2iexit 0" scripts/depmod.sh || die

	make ${xmakeopts} mrproper || die "mrproper failed"
}

kernel_src_configure() {
	env_setup_xmakeopts

	restore_config .config

	if [[ -f .config ]]; then
		make ${xmakeopts} olddefconfig >/dev/null
		return 0
	else
		ewarn "Could not locate user config file, so we will use a default one"
		make ${xmakeopts} defconfig >/dev/null
		return 0
	fi

	make ${xmakeopts} prepare 2>/dev/null
}

kernel_src_compile() {
	env_setup_xmakeopts

	# Build kernel image.
	emake ${xmakeopts} bzImage 2>/dev/null

	# Buld kernel modules if detected.
	if [[ $(grep "CONFIG_MODULES=y" .config 2>/dev/null) != "" ]]; then
		einfo "Module support in kernel detected, building modules"
		emake ${xmakeopts} modules 2>/dev/null
	fi
}

kernel_src_install() {
	env_setup_xmakeopts

	einfo "Install kernel"
	insinto boot
	newins arch/${KARCH}/boot/bzImage vmlinuz-${MY_PV}

	if [[ $(grep "CONFIG_MODULES=y" .config 2>/dev/null) != "" ]]; then
		einfo "Install modules"
		make ${xmakeopts} INSTALL_MOD_PATH="${ED}" INSTALL_MOD_STRIP="1" modules_install || die
		depmod -b "${ED}" -F System.map "${MY_PV}" || die
		rm -rf "${ED}/lib/firmware"
	fi

	if use mheaders ; then
		einfo "Install header files and scripts for building external modules for kernel"
		rm -rf "${ED}/${KMDIR}/build" || die
		rm -rf "${ED}/${KMDIR}/source"

		insinto "${KMDIR}/build/.tmp_versions"

		insinto "${KMDIR}/build"
		doins .config
		doins Makefile
		doins System.map

		insinto "${KMDIR}/build/kernel"
		doins kernel/Makefile

		insinto "${KMDIR}/build/include"
		for i in acpi asm-generic config crypto drm generated keys linux math-emu \
			media net pcmcia scsi sound trace uapi video xen ; do
			doins -r include/${i}
		done

		# Copy arch includes for external modules.
		insinto "${KMDIR}/build/arch/${KARCH}"
		doins -r arch/${KARCH}/include

		# Copy files necessary for later builds, like nvidia and vmware.
		insinto "${KMDIR}/build"
		doins Module.symvers

		# I dnot know how copy with doins and preserve file modes.
		#doins -r scripts
		cp -a scripts "${ED}/${KMDIR}/build"

		# Fix permissions on scripts dir.
		chmod og-w -R "${ED}/${KMDIR}/build/scripts"

		insinto "${KMDIR}/build/arch/${KARCH}"
		doins arch/${KARCH}/Makefile

		if [[ "${CARCH}" = "i686" ]]; then
			insinto "${KMDIR}/build/arch/${KARCH}"
			doins arch/${KARCH}/Makefile_32.cpu
		fi

		insinto "${KMDIR}/build/arch/${KARCH}/kernel"
		doins arch/${KARCH}/kernel/asm-offsets.s

		# Add docbook makefile.
		insinto "${KMDIR}/build/Documentation/DocBook"
		doins Documentation/DocBook/Makefile

		# Add dm headers.
		insinto "${KMDIR}/build/drivers/md"
		doins drivers/md/*.h

		# Add inotify.h
		insinto "${KMDIR}/build/include/linux"
		doins include/linux/inotify.h

		# Add wireless headers.
		insinto "${KMDIR}/build/net/mac80211"
		doins net/mac80211/*.h

		if [[ $(grep -E "CONFIG_DVB_CORE=(y|m)" .config 2>/dev/null) != "" ]]; then
			# Add dvb headers for external modules.
			# In reference to: http://bugs.archlinux.org/task/9912
			insinto "${KMDIR}/build/drivers/media/dvb-core"
			doins drivers/media/dvb-core/*.h
			# and...
			# http://bugs.archlinux.org/task/11194
			insinto "${KMDIR}/build/include/config/dvb"
			doins include/config/dvb/*.h

			# Add dvb headers.
			# In reference to: http://bugs.archlinux.org/task/20402
			insinto "${KMDIR}/build/drivers/media/usb/dvb-usb"
			doins drivers/media/usb/dvb-usb/*.h
			insinto "${KMDIR}/build/drivers/media/dvb-frontends"
			doins drivers/media/dvb-frontends/*.h
		fi

		insinto "${KMDIR}/build/drivers/media/tuners"
		doins drivers/media/tuners/*.h

		insinto "${KMDIR}/build/drivers/media/i2c"
		doins drivers/media/i2c/msp3400-driver.h

		# Add xfs and shmem for aufs building.
		insinto "${KMDIR}/build/fs/xfs"
		insinto "${KMDIR}/build/mm"

		# Copy in Kconfig files.
		for i in $(find . -name "Kconfig*"); do
			insinto "${KMDIR}"/build/$(echo ${i} | sed 's|/Kconfig.*||')
			doins ${i}
		done
	fi

	save_config .config
}

kernel_pkg_postinst() {
	savedconfig_pkg_postinst

	if use symlink; then
		symlink_rm_ln "vmlinuz-${MY_PV}" "${EROOT}boot/vmlinuz-latest"

		# NOTE: We can use 'eselect linux ${MY_PV}' but he add one more / in symlink
		mkdir -p "${EROOT}usr/src"
		symlink_rm_ln "${KMDIR}/build" "${EROOT}usr/src/linux"
	fi

	if use dracut ; then
		dracut --force --kmoddir "${EROOT}/${KMDIR}" "${EROOT}boot/initramfs-${MY_PV}" ${MY_PV} \
			|| die "failed create initramfs image"

		use symlink && symlink_rm_ln "initramfs-${MY_PV}" "${EROOT}boot/initramfs-latest"
	fi

	einfo
	einfo "If your need generate initramfs image use sys-kernel/dracut or mkinitcpio tools."
	einfo
	einfo "Run as root 'eselect linux' for switch between available kernel."
	einfo
	einfo "Run 'emerge @module-rebuild' for rebuild external drivers with new kernel."
	einfo
}

###############################################################################
# Export functions
###############################################################################

linux-kernel_src_prepare() {
	eapply_user

	[[ ${ETYPE} == headers ]] && headers_src_prepare
	[[ ${ETYPE} == kernel ]] && kernel_src_prepare
}

linux-kernel_src_configure() {
	[[ ${ETYPE} == headers ]] && return 0
	[[ ${ETYPE} == kernel ]] && kernel_src_configure
}

linux-kernel_src_compile() {
	[[ ${ETYPE} == headers ]] && headers_src_compile
	[[ ${ETYPE} == kernel ]] && kernel_src_compile
}

linux-kernel_src_install() {
	[[ ${ETYPE} == headers ]] && headers_src_install
	[[ ${ETYPE} == kernel ]] && kernel_src_install
}

linux-kernel_pkg_postinst() {
	[[ ${ETYPE} == headers ]] && return 0
	[[ ${ETYPE} == kernel ]] && kernel_pkg_postinst
}
