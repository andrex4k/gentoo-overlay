# Copyright 1999-2018 Mikhail Klementev
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils

DESCRIPTION="Linux kernel"
HOMEPAGE="https://kernel.org/"
SRC_URI="https://cdn.kernel.org/pub/linux/kernel/v4.x/linux-${PV}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+grub +initramfs +multilib cryptsetup kspp video_cards_intel"

DEPEND="sys-devel/make
	sys-devel/binutils:*
	dev-lang/perl
	sys-devel/bc
	grub? ( sys-boot/grub:* )
	initramfs? ( sys-kernel/genkernel )"

RDEPEND="${DEPEND}"

ARCH=x86

apply_config() {
	CONFIG=${1}
	grep -v -e '^#' -e '^$' ${CONFIG} | while read CONF; do
		config --${CONF}
	done
}

src_prepare() {
	default
	PATH=$PATH:./scripts/

	# /etc/linux/Kconfig
	# config INTEL_NUC_7I7DN
	#	  bool "Intel NUC 7i7DN"
	#	  default y
	#
	#	  select BLABLABLA
	#	  ...
	if [ -e /etc/linux/Kconfig ]; then
		echo 'source "/etc/linux/Kconfig"' >> Kconfig
	fi

	make defconfig 2>&1 | grep -i warning && die "Broken config"

	if use cryptsetup; then
		config --enable DM_CRYPT
		config --enable CRYPTO_USER_API_SKCIPHER
		config --enable CRYPTO_AES_NI_INTEL
	fi

	use kspp && apply_config "${FILESDIR}/kspp.config"

	use multilib && config --enable IA32_EMULATION

	use video_cards_intel && {
		config --enable DRM_I915
		config --enable DRM_I915_ALPHA_SUPPORT
	}

	# /etc/portage/make.conf:
	# KCONFIG="KVM KVM_INTEL"
	#	  ...
	for i in $KCONFIG; do
		config --enable ${i}
	done

	# --set-val duplicates and it produce warning :c
	sed -i "s;CONFIG_EXTRA_FIRMWARE=\"\";CONFIG_EXTRA_FIRMWARE=\"${LINUX_FIRMWARE}\";" .config

	make olddefconfig 2>&1 | grep -i warning && die "Broken config"
	make syncconfig 2>&1 | grep -i warning && die "Broken config"
}

src_install() {
	mkdir -p ./boot
	make install INSTALL_PATH=./boot
	insinto /usr/share/linux-${PV}/
	ls ./boot | while read file; do
		doins ./boot/${file}
	done
}

pkg_postinst() {
	# Hack for leave all kernel files after unmerge, to be able to boot old kernel
	cp /usr/share/linux-${PV}/* /boot/

	if use initramfs; then
		use cryptsetup && GENKERNEL_ARGS=--luks
		genkernel ${GENKERNEL_ARGS} initramfs --kerneldir=${S}
	fi

	use grub && grub-mkconfig -o /boot/grub/grub.cfg
}
