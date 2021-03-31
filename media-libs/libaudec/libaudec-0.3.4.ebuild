# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson

if [[ ${PV} != *9999* ]]; then
	SRC_URI="https://git.zrythm.org/cgit/libaudec/snapshot/${P}.tar.gz"
	KEYWORDS="~amd64"
else
	inherit git-r3
	EGIT_REPO_URI="https://git.zrythm.org/git/libaudec"
fi

DESCRIPTION="A library for reading and resampling audio files"
HOMEPAGE="https://git.zrythm.org/cgit/libaudec/"
LICENSE="AGPL-3"
SLOT="0"

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND="
	>=dev-util/meson-0.55.0
"
