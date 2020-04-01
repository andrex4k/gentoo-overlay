# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit golang-build

EGO_PN="github.com/jesseduffield/lazygit"
COMMIT="3e36affa69f2f94fbb779931034b303ecacb1ee2"
DESCRIPTION="A simple terminal UI for git commands"
HOMEPAGE="https://github.com/jesseduffield/lazygit"

if [[ ${PV} == "9999" ]]; then
EGIT_REPO_URI="https://${EGO_PN}.git"
EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
inherit git-r3
else
SRC_URI="https://${EGO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64 ~x86"
fi

LICENSE="MIT"
SLOT="0"
IUSE=""

DEPEND=">=dev-lang/go-1.14"
RDEPEND="dev-vcs/git"

src_compile() {
	if [[ ${PV} == "9999" ]]; then
	GO_FLAGS="${GOFLAGS}" VERBOSE="true" go build \
	-ldflags=" -X main.commit=current -X main.date=$(date -u +%Y-%m-%dT%H:%M:%SZ) -X main.buildSource=git -X main.version=git"
	else
	GO_FLAGS="${GOFLAGS}" VERBOSE="true" go build \
	-ldflags=" -X main.commit=${COMMIT} -X main.date=$(date -u +%Y-%m-%dT%H:%M:%SZ) -X main.buildSource=binaryRelease -X main.version=${PV}"
	fi
}

src_install() {
	dobin "${PN}"
	local DOCS=( ${S}/*.md ${S}/docs/*.md )
	einstalldocs
#dodoc -r docs/*
}

pkg_postinst() {
	ewarn "This is govnodebild. It is make by me for Sconst"
	ewarn
	ewarn "For all the questions, go fuck yourself"
}
