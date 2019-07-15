# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit unpacker gnome2-utils xdg-utils

DESCRIPTION="Boost Happiness, Productivity and Creativity."
HOMEPAGE="https://boostnote.io/"
SRC_URI="
	amd64? ( https://github.com/BoostIO/boost-releases/releases/download/v${PV}/boostnote_${PV}_amd64.deb -> ${P}-amd64.deb )
"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64"
IUSE=""

RDEPEND="
	gnome-base/gconf
	x11-libs/libX11
"

S=${WORKDIR}

src_install () {
	dodir /
	cd "${ED}" || die
	unpacker
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
	xdg_desktop_database_update
}

pkg_postrm() {
	gnome2_icon_cache_update
	xdg_desktop_database_update
}
