# Copyright 1999-2020 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

EGIT_REPO_URI="https://github.com/LongSoft/UEFITool"
EGIT_BRANCH="new_engine"
inherit desktop qmake-utils git-r3 xdg-utils

DESCRIPTION="UEFITool is a cross-platform C++/Qt program for parsing, extracting and modifying UEFI firmware images"
HOMEPAGE="https://github.com/LongSoft/UEFITool"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

LICENSE="BSD"
SLOT="0"

BDEPEND="
	!sys-apps/uefitool
	dev-qt/qtgui:5
	"

src_prepare() {
	cd "${S}"/UEFIExtract
		cmake CMakeLists.txt
	cd "${S}"/UEFIFind
		cmake CMakeLists.txt
	cd "${S}"/UEFITool
		eqmake5 uefitool.pro
	default
}

src_compile() {
	cd "${S}"/UEFITool
		emake
	cd "${S}"/UEFIFind
		emake
	cd "${S}"/UEFIExtract
		emake
}

src_install() {
	newbin UEFITool/UEFITool uefitool || die
	dobin UEFIExtract/UEFIExtract || die
	dobin UEFIFind/UEFIFind || die
local res
	for res in 16 32 48 64 128 256 512; do
		newicon -s ${res} UEFITool/icons/uefitool_${res}x${res}.png uefitool.png || die
	done
	domenu ""${S}"/UEFITool/uefitool.desktop" || die
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}
