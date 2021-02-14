# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )
inherit distutils-r1

DESCRIPTION="Enhanced Sphinx theme (based on Python 3 docs)"
HOMEPAGE="https://github.com/ionelmc/sphinx-py3doc-enhanced-theme
	https://pypi.org/project/sphinx_py3doc_enhanced_theme/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~mips ppc ppc64 ~riscv s390 sparc x86"
IUSE=""