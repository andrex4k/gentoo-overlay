# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id: 6a5a8b562b40678acd69abea8e76f2c37ae4338d $

EAPI=5
inherit eutils systemd udev

ADRIVER_PV="1.0.25"

DESCRIPTION="Advanced Linux Sound Architecture Utils (alsactl, alsamixer, etc.)"
HOMEPAGE="http://www.alsa-project.org/"
SRC_URI="mirror://alsaproject/utils/${P}.tar.bz2
	mirror://alsaproject/driver/alsa-driver-${ADRIVER_PV}.tar.bz2"

LICENSE="GPL-2"
SLOT="0.9"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 ~sh sparc x86"
IUSE="doc +libsamplerate +ncurses nls selinux"

CDEPEND=">=media-libs/alsa-lib-1.0.27.1
	libsamplerate? ( media-libs/libsamplerate )
	ncurses? ( >=sys-libs/ncurses-5.7-r7:0= )"
DEPEND="${CDEPEND}
	virtual/pkgconfig
	doc? ( app-text/xmlto )"
RDEPEND="${CDEPEND}
	selinux? ( sec-policy/selinux-alsa )"

src_prepare() {
	epatch_user
}

src_configure() {
	local myconf
	use doc || myconf='--disable-xmlto'

	# --disable-alsaconf because it doesn't work with sys-apps/kmod wrt #456214
	econf \
		--disable-maintainer-mode \
		$(use_enable libsamplerate alsaloop) \
		$(use_enable nls) \
		$(use_enable ncurses alsamixer) \
		--disable-alsaconf \
		"$(systemd_with_unitdir)" \
		--with-udev-rules-dir="$(get_udevdir)"/rules.d \
		${myconf}
}

src_install() {
	emake DESTDIR="${D}" install

	dodoc ChangeLog README TODO seq/*/README.*

	newbin "${WORKDIR}/alsa-driver-${ADRIVER_PV}/utils/alsa-info.sh" alsa-info

	newinitd "${FILESDIR}"/alsasound.initd-r5 alsasound
	newconfd "${FILESDIR}"/alsasound.confd-r4 alsasound
	insinto /etc/modprobe.d
	newins "${FILESDIR}"/alsa-modules.conf-rc alsa.conf

	keepdir /var/lib/alsa

	# ALSA lib parser.c:1266:(uc_mgr_scan_master_configs) error: could not
	# scan directory /usr/share/alsa/ucm: No such file or directory
	# alsaucm: unable to obtain card list: No such file or directory
	keepdir /usr/share/alsa/ucm
}

pkg_postinst() {
	if [[ -z ${REPLACING_VERSIONS} ]]; then
		elog
		elog "To take advantage of the init script, and automate the process of"
		elog "saving and restoring sound-card mixer levels you should"
		elog "add alsasound to the boot runlevel. You can do this as"
		elog "root like so:"
		elog "# rc-update add alsasound boot"
		ewarn
		ewarn "The ALSA core should be built into the kernel or loaded through other"
		ewarn "means."
		ewarn "Automated (un)loading of ALSA modules is deprecated and unsupported."
		ewarn "Should you choose to use it, bug reports will not be accepted."
	fi
}
