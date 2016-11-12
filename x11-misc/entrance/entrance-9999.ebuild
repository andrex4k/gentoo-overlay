# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit autotools eutils git-2 pam

DESCRIPTION="Display-manager based on efl"
HOMEPAGE="http://www.enlightenment.org/"
SRC_URI=""
EGIT_REPO_URI="http://git.enlightenment.org/misc/entrance.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="consolekit ekbd grub2 pam"

RDEPEND="
	>=dev-libs/efl-1.8.1
	>=media-libs/elementary-1.8.0
	app-admin/sudo
	sys-apps/dbus
	x11-libs/libxcb
	consolekit? ( sys-auth/consolekit )
	pam? ( sys-libs/pam )"
DEPEND="${RDEPEND}
	!<sys-apps/systemd-192
	virtual/pkgconfig"

src_prepare() {
	epatch "${FILESDIR}"/0001-disable-check-for-systemd.patch
	eautoreconf
}

src_configure() {
	local config=(
		$(use_enable consolekit)
		$(use_enable ekbd)
		$(use_enable grub2)
		$(use_enable pam)
		# only installs unit file for now
		--enable-systemd
	)

	econf "${config[@]}"
}

src_install() {
	default

	newpamd "${FILESDIR}"/entrance.pamd entrance
}
