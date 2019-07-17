# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LICENSE="GPL-3"

KEYWORDS="~amd64 ~x86"

SLOT="0"

IUSE=""

CMAKE_MIN_VERSION="3.3"

inherit eutils xdg cmake-utils toolchain-funcs flag-o-matic multilib

DESCRIPTION="CoreCtrl is a Free and Open Source GNU/Linux application that allows you to control with ease your computer hardware using application profiles. It aims to be flexible, comfortable and accessible to regular users."
HOMEPAGE="https://gitlab.com/corectrl"
SRC_URI="https://gitlab.com/corectrl/corectrl/-/archive/v1.0.3/corectrl-v1.0.3.tar.gz"

RDEPEND="
	app-arch/xz-utils:=
	dev-qt/qtcore:5=
	dev-qt/qtdbus:5=
	dev-qt/qtnetwork:5=
	dev-qt/qtwidgets:5=[xcb,png]
	dev-qt/qtcharts:5=
	kde-frameworks/extra-cmake-modules:5=
	dev-qt/qtcharts:5=
	kde-frameworks/kauth:5=
	kde-frameworks/karchive:5=
	app-crypt/qca[botan]
"
DEPEND="
	|| (
		>=sys-devel/gcc-8.2.0-r6
		(
			>=sys-devel/clang-7.1.0
		)
	)

	virtual/pkgconfig
	${RDEPEND}
	"

src_prepare() {
	epatch "${FILESDIR}/${P}/0001_fix-lib.patch"
}



S=${WORKDIR}/${PN}-v${PV}
CMAKE_USE_DIR=${WORKDIR}/${PN}-v${PV}

src_configure() {
	local mycmakeargs=(
		-DLIB_INSTALL_DIR="/usr/$(get_libdir)"
		-DLIBDIR="$(get_libdir)"
                -DCMAKE_BUILD_TYPE=Release
                -DBUILD_TESTING=OFF
		-DCMAKE_INSTALL_PREFIX=/usr
	)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	default

}

pkg_preinst() {
	xdg_pkg_preinst
}

pkg_postinst() {
	xdg_pkg_postinst
}

pkg_postrm() {
	xdg_pkg_postrm
}
