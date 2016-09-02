# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit git-r3 vim-plugin

DESCRIPTION="Next generation completion framework after neocomplcache"
HOMEPAGE="https://github.com/Shougo/neocomplete.vim"
EGIT_REPO_URI="https://github.com/Shougo/neocomplete.vim.git"

LICENSE="MIT"

RDEPEND="
	|| (
		>app-editors/vim-7.3.885[lua]
		>app-editors/gvim-7.3.885[lua]
	)

	!app-vim/neocomplcache
"

src_prepare() {
	# remove unwanted files
	rm -r test || die
}
