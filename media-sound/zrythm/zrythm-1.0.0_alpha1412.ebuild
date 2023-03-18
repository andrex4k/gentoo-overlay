# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson xdg-utils gnome2-utils

MY_PV="1.0.0-alpha.14.1.2"
MY_P="${PN}-${MY_PV}"
S="${WORKDIR}/${MY_P}"
SRC_URI="https://www.zrythm.org/releases/${MY_P}.tar.xz"
KEYWORDS="~amd64"

DESCRIPTION="Zrythm is a digital audio workstation designed to be featureful and easy to use."
HOMEPAGE="https://www.zrythm.org/"
LICENSE="GPL-3"
SLOT="0"

DEPEND="
	app-arch/zstd
	dev-libs/libcyaml
	dev-libs/libbacktrace
	>=dev-libs/reproc-14.1.0
	dev-scheme/guile
	kde-frameworks/breeze-icons
	media-libs/lilv
	>=media-libs/libaudec-0.2.3
	media-libs/libsoundio
	media-libs/chromaprint
	media-libs/rubberband
	sci-libs/fftw:*[threads]
	x11-libs/gtk+:3
	x11-libs/gtksourceview:*
"
RDEPEND="${DEPEND}"
BDEPEND="
	>=dev-util/meson-0.57.0
"
#PATCHES=(
#	"${FILESDIR}/${P}-fix_version.patch"
#)

src_prepare() {
	eapply "${FILESDIR}/${P}-fix_version.patch"
	eapply_user
}

src_install() {
	DESTDIR="${D}" eninja -C "${BUILD_DIR}" install
}

pkg_postinst() {
	xdg_mimeinfo_database_update
	xdg_desktop_database_update
	xdg_icon_cache_update
	gnome2_schemas_update
}

pkg_postrm() {
	xdg_mimeinfo_database_update
	xdg_desktop_database_update
	xdg_icon_cache_update
	gnome2_schemas_update
}
