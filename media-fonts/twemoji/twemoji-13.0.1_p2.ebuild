# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit font

FEDREL="fc33"
MY_PV="${PV/_p/-}.${FEDREL}"

DESCRIPTION="Twitter Emoji for everyone."
HOMEPAGE="https://github.com/twitter/twemoji"
SRC_URI="https://archives.fedoraproject.org/pub/fedora/linux/development/rawhide/Everything/x86_64/os/Packages/${PN:0:1}/twitter-${PN}-fonts-${MY_PV}.noarch.rpm"

LICENSE="MIT CC-BY-4.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
RESTRICT="bindist mirror"
S="${WORKDIR}/usr/share/fonts/${PN}"
FONT_S="${S}"
FONT_CONF=( "${FILESDIR}/75-${PN}.conf" )
FONT_SUFFIX="ttf"
DEPEND="
	app-arch/libarchive[zstd]"

src_unpack() {
	bsdtar xf "${DISTDIR}/${A}" || die
}
