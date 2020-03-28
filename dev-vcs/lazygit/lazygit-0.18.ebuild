# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit 

MY_PN="github.com/jesseduffield/lazygit"
COMMIT="5d460e1e5e002ae3f4deb6b75e77b5916d672cc5"
DESCRIPTION="A simple terminal UI for git commands"
HOMEPAGE="https://github.com/jesseduffield/lazygit"
SRC_URI="https://${MY_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
DEPEND=">=dev-lang/go-1.14"
RDEPEND="dev-vcs/git"
src_compile() {
	set -- env GO111MODULE=on go build -mod vendor -v -x -o lazygit \
	-ldflags="-X main.commit=${COMMIT} -X main.version=${PV}" \
	main.go
	echo "$@"
	"$@" || die
}
src_install() {
	dobin lazygit
	local DOCS=( ${S}/*.md ${S}/docs/*.md )
	einstalldocs
#dodoc -r docs/*
}
pkg_postinst() {
	ewarn "This is govnodebild. It is make by me for Sconst"
	ewarn
	ewarn "For all the questions, go fuck yourself"
}
