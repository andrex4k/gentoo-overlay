# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )=( python3_{7,8,9} )
DISTUTILS_USE_SETUPTOOLS=no
inherit distutils-r1

DESCRIPTION="CSS minifier written in python."
HOMEPAGE="http://opensource.perlig.de/rcssmin/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

DOCS=""
python_install_all() {
	distutils-r1_python_install_all
	mv "${D}/usr/share/doc/${PN}" "${D}/usr/share/doc/${PF}"
}
