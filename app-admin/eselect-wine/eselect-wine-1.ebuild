# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=8

DESCRIPTION="Wine eselect module and env support"
HOMEPAGE="http://www.github.com/chaoskagami/chaos-overlay"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=app-admin/eselect-1.2.4"
RDEPEND="${DEPEND}"

S="${WORKDIR}"

src_install() {
	dodir /usr/share/eselect/modules/
	cp "${FILESDIR}"/wine.eselect "${D}"/usr/share/eselect/modules/wine.eselect

	dodir /etc/env.d/
	cp "${FILESDIR}"/90wine "${D}"/etc/env.d/90wine
}

pkg_postinst() {
	elog "Reconfiguring to use first wine instance."

	eselect wine set 1
}
