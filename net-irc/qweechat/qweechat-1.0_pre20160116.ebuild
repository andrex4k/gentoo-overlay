# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit git-r3 distutils-r1

DESCRIPTION="Qt remote GUI for WeeChat"
HOMEPAGE="https://weechat.org"
SRC_URI=""
EGIT_REPO_URI="https://github.com/weechat/qweechat.git"
EGIT_COMMIT="356719e00de8446ece29f41ca15da2a26c098ecf"
LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND="dev-python/pyside[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"
