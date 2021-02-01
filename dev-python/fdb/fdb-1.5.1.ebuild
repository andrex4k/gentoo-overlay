# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python3_{7..9} )=( python3_{7..9} )

inherit distutils-r1

DESCRIPTION="Firebird RDBMS bindings for Python."
HOMEPAGE="https://pypi.python.org/pypi/fdb/"
SRC_URI="mirror://pypi/f/fdb/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="fb15 +fb30"
REQUIRED_USE="|| ( fb15 fb30 )"

RDEPEND="
	fb15? ( <=dev-db/firebird-bin-1.5.6.5026 )

	fb30? ( >=dev-db/firebird-3.0.0.32136 )
"

DEPEND="
	${RDEPEND}
	${PYTHON_DEPS}

	dev-python/setuptools
"
