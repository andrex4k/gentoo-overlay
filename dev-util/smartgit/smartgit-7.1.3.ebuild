# Copyright 2015-2016 Jan Chren (rindeal)
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils versionator

PN_PRETTY="SmartGIT"

DESCRIPTION="Git client with support for GitHub Pull Requests+Comments, SVN and Mercurial"
HOMEPAGE="http://www.syntevo.com/smartgit"
SRC_URI="http://www.syntevo.com/static/smart/download/smartgit/${PN}-linux-${PV//./_}.tar.gz"

SLOT="0"
LICENSE="smartgit"
KEYWORDS="~amd64 ~x86"

RESTRICT="mirror strip"

RDEPEND="
	>=virtual/jre-1.7:1.7
	|| ( dev-vcs/git dev-vcs/mercurial )
"

S="${WORKDIR}/${PN}"

src_install() {
	local install_dir="/opt/${PN_PRETTY}"

	for s in 32 48 64 128 256; do
		newicon -s $s "bin/smartgit-${s}.png" "${PN}.png"
	done

	insinto "$install_dir"
	doins -r .

	fperms a+x "$install_dir/"{bin,lib}/*.sh

	dosym "$install_dir/bin/smartgit.sh" "/usr/bin/${PN}"

	make_desktop_entry_args=(
		"${PN} %U"								# exec
		"${PN_PRETTY}"							# name
		"${PN}"									# icon
		"Development"							# categories
	)
	make_desktop_entry_extras=(
	)
	make_desktop_entry "${make_desktop_entry_args[@]}" \
		"$( printf '%s\n' "${make_desktop_entry_extras[@]}" )"
}

pkg_postinst() {
	elog "${PN} relies on external git/hg executables to work."
	optfeature "Git support" dev-vcs/git
	optfeature "Mercurial support" dev-vcs/mercurial
}
