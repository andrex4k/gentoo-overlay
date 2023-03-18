# Copyright 1999-2020 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python{3_6,3_7,3_8} )

inherit toolchain-funcs distutils-r1

#EHG_REVISION=bf25f416f615a43267abecab4c599e86f363438b # 1.2
DESCRIPTION="Asounconf fork with fixes to work with recent ALSA"
HOMEPAGE="https://bitbucket.org/stativ/asoundconf"
#EHG_REPO_URI="https://bitbucket.org/stativ/asoundconf#revision="
#HG_REVISION=bf25f416f615a43267abecab4c599e86f363438b
SRC_URI="https://bitbucket.org/stativ/${PN}/get/${PV}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

RDEPEND="${PYTHON_DEPS}
	dev-python/pygobject[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}"
# TODO: Test and fix it!!!!
PATCHES=(
	"${FILESDIR}/${PN}-python3-syntax.patch"
	"${FILESDIR}/${PN}-python3-spaces.patch"
	"${FILESDIR}/${PN}-python3-gobject.patch"
)

S="${WORKDIR}/stativ-asoundconf-55cdf2e78b7f"
python_prepare_all() {
	distutils-r1_python_prepare_all
}
python_compile_all() {
	distutils-r1_python_compile_all
}

python_install_all() {
		distutils-r1_python_install_all
}