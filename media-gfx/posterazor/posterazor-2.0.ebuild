# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
EAPI=3

inherit git-2

DESCRIPTION="PosteRazor cuts raster images into multipage PDF documents."
HOMEPAGE="http://posterazor.sourceforge.net/"
LICENSE="GPL-2"
SLOT="0"
EGIT_REPO_URI="git://github.com/aportale/posterazor.git"
SRC_URI=""
S=${WORKDIR}/${PN}

KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="media-libs/freeimage
x11-libs/qt-gui"
DEPEND="${RDEPEND}"
src_compile() {
	cd src
	qmake -o Makefile posterazor.pro
	make
}
src_install() {
	mv ${S}/src/PosteRazor ${S}/src/posterazor
	exeinto /usr/bin
	doexe ${S}/src/posterazor
	dodoc ${S}/CHANGES ${S}/LICENSE ${S}/README

}
