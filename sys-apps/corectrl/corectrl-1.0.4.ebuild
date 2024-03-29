# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LICENSE="GPL-3"

KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

SLOT="0"

IUSE="debug doc kernel_linux opengl test vulkaninfo"

CMAKE_MIN_VERSION="3.3"

inherit xdg cmake-utils gnome2-utils

DESCRIPTION="CoreCtrl is control with ease your computer hardware using application profiles."
HOMEPAGE="https://gitlab.com/corectrl/corectrl"
SRC_URI="https://gitlab.com/${PN}/${PN}/-/archive/v${PV}/${PN}-v${PV}.tar.gz"

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
	kernel_linux? ( sys-apps/util-linux )
	opengl? ( x11-apps/mesa-progs )
	vulkaninfo? ( dev-util/vulkan-tools:=[vulkaninfo] )
"
DEPEND="
	|| (
		>=sys-devel/gcc-8.2.0-r6
		(
			>=sys-devel/clang-7.1.0
		)
	)
	sys-apps/hwids
	virtual/pkgconfig
	${RDEPEND}
	"

src_prepare() {
	#fix libdir path cmakef
	epatch "${FILESDIR}/patch/0001_fix-lib.patch"
	default
}

S=${WORKDIR}/${PN}-v${PV}
CMAKE_USE_DIR=${WORKDIR}/${PN}-v${PV}

src_configure() {
	local mycmakeargs=(
		-DLIB_INSTALL_DIR="/usr/$(get_abi_LIBDIR)"
		-DLIBDIR="$(get_libdir)"
		-DCMAKE_BUILD_TYPE=Release
		-DBUILD_TESTING="$(usex test)"
		-DCMAKE_INSTALL_PREFIX=/usr
		#-DCMAKE_DOC_DIR=/share/doc/${PF}
	)
	if use debug; then
                mycmakeargs+=(
                        -DCMAKE_BUILD_TYPE=Debug
				)
        fi
	sed -i -- 's/\/usr/${CMAKE_INSTALL_PREFIX}/g' src/helper/cmake_install.cmake
	cmake-utils_src_configure
	default
}

cmake_src_test() {
	cmake-utils_src_test
	cmake_src_test
}

src_install() {
	cmake-utils_src_install
	default
}

pkg_preinst() {
	xdg_pkg_preinst
}

pkg_postinst() {
	gnome2_icon_cache_update
	xdg_pkg_postinst
}
#for the future
pkg_postrm ()  {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
}
