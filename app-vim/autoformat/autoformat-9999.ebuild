# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit git-r3 vim-plugin

DESCRIPTION="Provide easy code formatting in vim by integrating existing code formatters"
HOMEPAGE="https://github.com/Chiel92/vim-autoformat"
EGIT_REPO_URI="https://github.com/Chiel92/vim-autoformat.git"

LICENSE="MIT"

src_prepare() {
	# remove unwanted files
	rm -r samples || die
}
