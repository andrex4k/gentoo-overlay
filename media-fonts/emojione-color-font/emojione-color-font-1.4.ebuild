# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit font

DESCRIPTION="A color and B&W emoji SVG-in-OpenType font"
HOMEPAGE="https://github.com/eosrei/emojione-color-font"
SRC_URI="${HOMEPAGE}/releases/download/v${PV//_/-}/EmojiOneColor-SVGinOT-Linux-${PV//_/-}.tar.gz"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
LICENSE="MIT CC-BY-4.0"
SLOT="0"
IUSE=""

#The media-fonts/ttf-bitstream-vera package was masked due to #282754 bug, so it recommends to use media-fonts/dejavu instead
DEPEND="
	|| (
		media-fonts/ttf-bitstream-vera[X?]
		media-fonts/dejavu[X?]
	)
	app-i18n/unicode-data"
RDEPEND="${DEPEND}"

FONT_SUFFIX="ttf"
DOCS="README.md"
FONT_CONF=( fontconfig/56-emojione-color.conf )
S="${WORKDIR}/EmojiOneColor-SVGinOT-Linux-${PV//_/-}"
FONT_S="${S}"
PATCHES=( "${FILESDIR}/${PN}-match-fix.patch" )
