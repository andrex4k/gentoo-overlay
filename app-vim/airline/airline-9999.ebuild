# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit git-r3 vim-plugin

DESCRIPTION="vim plugin: lean & mean statusline for vim that's light as air"
HOMEPAGE="https://github.com/vim-airline/vim-airline/ http://www.vim.org/scripts/script.php?script_id=4661"
EGIT_REPO_URI="https://github.com/vim-airline/vim-airline.git"

LICENSE="MIT"

VIM_PLUGIN_HELPFILES="${PN}.txt"

src_prepare() {
	# remove unwanted files
	rm -r t Gemfile Rakefile LICENSE README* || die
}
