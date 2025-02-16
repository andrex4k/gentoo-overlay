# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10,11,12} )

inherit distutils-r1

DESCRIPTION="A tool for generating Gentoo ebuilds from various package formats"
HOMEPAGE="https://github.com/andrex4k/make_ebuild"
SRC_URI="https://github.com/andrex4k/make_ebuild/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
    dev-python/click[${PYTHON_USEDEP}]
    dev-python/python-magic[${PYTHON_USEDEP}]
    dev-python/python-debian[${PYTHON_USEDEP}]
    dev-python/jinja[${PYTHON_USEDEP}]
    dev-python/distro[${PYTHON_USEDEP}]
    dev-python/py7zr[${PYTHON_USEDEP}]
    dev-python/rarfile[${PYTHON_USEDEP}]
    dev-python/requests[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"

BDEPEND="
    test? (
    )
"

distutils_enable_tests pytest