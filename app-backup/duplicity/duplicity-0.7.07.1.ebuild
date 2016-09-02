# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Secure backup system using gnupg to encrypt data"
HOMEPAGE="http://www.nongnu.org/duplicity/"
SRC_URI="https://code.launchpad.net/duplicity/0.7-series/${PV}/+download/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="s3 test"

CDEPEND="
	app-crypt/gnupg

	dev-python/lockfile

	net-libs/librsync
"

DEPEND="${CDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]

	test? ( dev-python/mock[${PYTHON_USEDEP}] )
"

RDEPEND="${CDEPEND}
	dev-python/paramiko[${PYTHON_USEDEP}]

	s3? ( dev-python/boto[${PYTHON_USEDEP}] )
"

python_prepare_all() {
	distutils-r1_python_prepare_all

	sed -i "s/'COPYING',//" setup.py || die "Couldn't remove unnecessary COPYING file."
}

python_test() {
	esetup.py test
}

pkg_postinst() {
	einfo "Duplicity has many optional dependencies to support various backends."
	einfo "Currently it's up to you to install them as necessary."
}
