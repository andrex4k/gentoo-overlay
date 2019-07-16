# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

LICENSE="GPL-3"

KEYWORDS="~amd64 ~x86"

SLOT="0"

IUSE=""

CMAKE_MIN_VERSION="3.3"

inherit eutils xdg cmake-utils toolchain-funcs flag-o-matic multilib

DESCRIPTION="Core control application"
HOMEPAGE="https://gitlab.com/corectrl"
SRC_URI="https://gitlab.com/corectrl/corectrl/-/archive/v1.0.3/corectrl-v1.0.3.tar.gz"

RDEPEND="
	app-arch/xz-utils:=
	dev-qt/qtcore:5=
	dev-qt/qtdbus:5=
	dev-qt/qtnetwork:5=
	dev-qt/qtwidgets:5=[xcb,png]
	dev-qt/qtcharts:5=
	dev-libs/botan:2=
	kde-frameworks/extra-cmake-modules:5=
	dev-qt/qtcharts:5=
	kde-frameworks/kauth:5=
	kde-frameworks/karchive:5=
	app-crypt/qca
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
	
	local CMAKE_MODULES_DIR=${S}/cmake
}

QA_TEXTRELS_x86="/usr/liblibcorectrl.so"

S=${WORKDIR}/${PN}-v${PV}
CMAKE_USE_DIR=${WORKDIR}/${PN}-v${PV}

src_configure() {
	ecmake	DLIBDIR="$(get_libdir)" \
		DCMAKE_BUILD_TYPE=Release \
		DBUILD_TESTING=OFF \
		DCMAKE_INSTALL_PREFIX=/usr
	#cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	default
	#emake DESTDIR="${D}" PREFIX="/usr" LIBDIR="$(get_libdir)" install
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
