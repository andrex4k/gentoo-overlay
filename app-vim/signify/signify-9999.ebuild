# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit git-r3 vim-plugin

DESCRIPTION="Show a diff via Vim sign column"
HOMEPAGE="https://github.com/mhinz/vim-signify"
EGIT_REPO_URI="https://github.com/mhinz/vim-signify.git"

LICENSE="MIT"

src_prepare() {
	# remove unwanted files
	rm -r pictures showcolors.bash || die
}
