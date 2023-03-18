# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=8

inherit git-r3 vim-plugin

DESCRIPTION="Vim plugin that displays tags in a window, ordered by scope"
HOMEPAGE="https://github.com/majutsushi/tagbar"
EGIT_REPO_URI="https://github.com/majutsushi/tagbar.git"

LICENSE="MIT"

src_prepare() {
	# remove unwanted files
	rm -r .info || die
}
