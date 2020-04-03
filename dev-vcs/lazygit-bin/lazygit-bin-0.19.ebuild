# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A simple terminal UI for git commands."
HOMEPAGE="https://github.com/jesseduffield/lazygit"
SRC_URI="https://github.com/jesseduffield/lazygit/releases/download/v${PV}/${PN/-bin}_${PV}_Linux_x86_64.tar.gz"

LICENSE="MIT"
SLOT="0"
IUSE=""
RESTRICT="mirror"
KEYWORDS="~amd64"

RDEPEND="dev-vcs/git"

S="${WORKDIR}"

src_unpack() {
	unpack ${A}
}

src_install() {
	dobin ${PN/-bin}
}
