# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit git-r3

DESCRIPTION="Open-source xray engine"
HOMEPAGE="https://github.com/OpenXRay"
LICENSE="BSD"

#EGIT_REPO_URI="https://github.com/OpenXRay/xray-16"

SRC_URI="https://github.com/OpenXRay/xray-16/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz" 

SLOT="0"
KEYWORDS="~amd64"
IUSE="debug"
RESTRICT=""
DEPEND="
		media-libs/glew:=
		media-libs/freeimage
		net-libs/liblockfile
		media-libs/openal
		dev-cpp/tbb
		dev-libs/crypto++
		media-libs/libtheora
		media-libs/libogg
		media-libs/libvorbis
		media-libs/libsdl2
		dev-libs/lzo
		media-libs/libjpeg-turbo
		sys-libs/readline
		dev-libs/libpcre2
		dev-libs/libpcre
		app-arch/lzop
		dev-vcs/git
		media-libs/libglvnd
"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${P}

src_configure() {
	mkdir ${S}/bin
	cd ${S}/bin
	if use debug; then
		cmake .. -DCMAKE_BUILD_TYPE=RelWithDebInfo -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_INSTALL_BINDIR=/usr/bin
	else
		cmake .. -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_INSTALL_BINDIR=/usr/bin
	fi
}

src_compile() {
	cd ${S}/bin
	emake
}

src_install() {
	cd ${S}/bin
	emake DESTDIR="${D}" install
}