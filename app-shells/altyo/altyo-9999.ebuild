# Copyright 2004-2013 Sabayon
# Distributed under the terms of the GNU General Public License v2
# $

EAPI=5

inherit git-2 vala

#EGIT_COMMIT="${PN}-${PV}-1"
DESCRIPTION="PVala / GTK3 drop-down terminal emulator"
HOMEPAGE="https://github.com/linvinus/AltYo"
EGIT_REPO_URI="git://github.com/linvinus/AltYo"
EGIT_PROJECT=AltYo


LICENSE="GPL-3"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE=""

RDEPEND="${DEPEND}
	>=dev-libs/glib-2
	x11-libs/gtk+:3
	x11-libs/vte:3"
DEPEND="${DEPEND}
	$(vala_depend)
	virtual/pkgconfig
	"
DOCS="AUTHORS README"
S=${WORKDIR}/${PN}



src_install() {
	dodir /usr/share/doc/${PN}
	cp "${S}"/{AUTHORS,README.*} "${D}"/usr/share/doc/${PN}
	emake DESTDIR="${ED}" install
}
