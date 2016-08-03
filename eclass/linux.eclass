# @ECLASS: linux.eclass
# @MAINTAINER:
# Igor Savlook <igorsavlook@gmail.com>
# @BLURB: Eclass for sys-kernel/linux package
# @DESCRIPTION:

case ${EAPI} in
	0|1|2|3|4) die "EAPI=${EAPI} not supported"
esac

inherit eutils flag-o-matic savedconfig versionator

EXPORT_FUNCTIONS src_prepare src_compile src_install pkg_postinst

if [[ "${CARCH}" == "i686" || "${CARCH}" == "x86_64" ]]; then
	KARCH="x86"
else
	KARCH="${CARCH}"
fi

KMAINVER=$(get_version_component_range 1)
KAPIVER=$(get_version_component_range 1-2)

# If kernel do not have patch version just download full tarball.
# Otherwise download full main tarball and patches.
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

	S="${WORKDIR}/linux-$(get_version_component_range 1-2)"
fi

KMDIR="lib/modules/${MY_PV}"

DESCRIPTION="Linux kernel"
HOMEPAGE="http://www.kernel.org/"
SRC_URI="${MY_SRC_URI}"

LICENSE="GPL-2"
SLOT="${PV}"
KEYWORDS="~amd64 ~x86"
IUSE="firmware +headers +mheaders"

RESTRICT="test"

RDEPEND="
	firmware? ( sys-kernel/linux-firmware )
	headers? ( =sys-kernel/linux-headers-${KAPIVER} )
	mheaders? ( app-admin/eselect-linux )
"

DEPEND="${RDEPEND}
	app-text/xmlto

	dev-lang/perl

	sys-apps/kmod

	sys-devel/bc
	>=sys-devel/gcc-4.9.3
"

linux_src_prepare() {
	if [[ $(get_version_component_count) -gt "2" ]]
	then
		epatch "${WORKDIR}/linux-patch-${PV}"
	fi

	# Don't run depmod on 'make install'. We'll do this ourselves.
	sed -i "2iexit 0" scripts/depmod.sh || die
}

linux_src_configure() {
	restore_config .config

	if [[ -f .config ]]; then
		emake ARCH=${KARCH} -j1 olddefconfig >/dev/null
		return 0
	else
		ewarn "Could not locate user configfile, so we will generate a new one"
		emake ARCH=${KARCH} -j1 allmodconfig >/dev/null
		return 0
	fi

	emake ARCH=${KARCH} prepare 2>/dev/null
}

linux_src_compile() {
	# Build kernel image.
	emake ARCH=${KARCH} bzImage 2>/dev/null

	# Buld kernel modules if detected.
	if [[ $(grep "CONFIG_MODULES=y" .config 2>/dev/null) != "" ]]; then
		einfo "Module support in kernel detected, building modules"
		emake ARCH=${KARCH} modules 2>/dev/null
	fi
}

linux_src_install() {
	einfo "Install kernel"
	insinto boot
	newins arch/${KARCH}/boot/bzImage vmlinuz-${MY_PV}

	if [[ $(grep "CONFIG_MODULES=y" .config 2>/dev/null) != "" ]]; then
		einfo "Install modules"
		emake ARCH=${KARCH} INSTALL_MOD_PATH="${D}" INSTALL_MOD_STRIP="1" modules_install || die
		depmod -b "${D}" -F System.map "${MY_PV}" || die
		rm -rf "${D}/lib/firmware"
	fi

	if use mheaders ; then
		einfo "Install header files and scripts for building external modules for kernel"
		rm -f "${D}/${KMDIR}/build"
		rm -f "${D}/${KMDIR}/source"

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
		cp -a scripts "${D}/${KMDIR}/build"

		# Fix permissions on scripts dir.
		chmod og-w -R "${D}/${KMDIR}/build/scripts"

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

		# Add dvb headers for external modules.
		# In reference to: http://bugs.archlinux.org/task/9912
		insinto "${KMDIR}/build/drivers/media/dvb-core"
		doins drivers/media/dvb-core/*.h
		# and...
		# http://bugs.archlinux.org/task/11194
		insinto "${KMDIR}/build/include/config/dvb"
		doins include/config/dvb/*.h

		# Add dvb headers for http://mcentral.de/hg/~mrec/em28xx-new
		# In reference to: http://bugs.archlinux.org/task/13146
		insinto "${KMDIR}/build/drivers/media/dvb-frontends"
		doins drivers/media/dvb-frontends/lgdt330x.h
		insinto "${KMDIR}/build/drivers/media/i2c"
		doins drivers/media/i2c/msp3400-driver.h

		# Add dvb headers.
		# In reference to: http://bugs.archlinux.org/task/20402
		insinto "${KMDIR}/build/drivers/media/usb/dvb-usb"
		doins drivers/media/usb/dvb-usb/*.h
		insinto "${KMDIR}/build/drivers/media/dvb-frontends"
		doins drivers/media/dvb-frontends/*.h
		insinto "${KMDIR}/build/drivers/media/tuners"
		doins drivers/media/tuners/*.h

		# Add xfs and shmem for aufs building.
		insinto "${KMDIR}/build/fs/xfs"
		insinto "${KMDIR}/build/mm"

		# Copy in Kconfig files.
		for i in $(find . -name "Kconfig*"); do
			insinto "${KMDIR}"/build/$(echo ${i} | sed 's|/Kconfig.*||')
			doins ${i}
		done

		# Remove unneeded architectures.
		#rm -rf "${D}/${KMDIR}/build/arch"/{alpha,arc,arm,arm26,arm64,avr32,blackfin,c6x,cris,frv,h8300,hexagon,ia64,m32r,m68k,m68knommu,metag,mips,microblaze,mn10300,openrisc,parisc,powerpc,ppc,s390,score,sh,sh64,sparc,sparc64,tile,unicore32,um,v850,xtensa}
	fi

	save_config .config
}

linux_pkg_postinst() {
	savedconfig_pkg_postinst

	echo
	ewarn "If your need generate initramfs image use sys-kernel/dracut or mkinitcpio tools."
	ewarn
	ewarn "Run as root 'eselect linux' for switch between available kernel."
	ewarn
	ewarn "Run 'emerge @module-rebuild' for rebuild"
	ewarn "external drivers with new kernel."
	echo
}
