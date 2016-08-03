# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

DESCRIPTION="Linux kernel eselect firmware and headers support"
HOMEPAGE="http://www.github.com/killer2tester/gentoo-overlay-lif"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

IUSE=""

RDEPEND=">=app-admin/eselect-1.2.4"
DEPEND="${RDEPEND}"

S="${WORKDIR}"

src_install() {
	dodir /usr/share/eselect/modules
	cp "${FILESDIR}/linux.eselect" "${D}/usr/share/eselect/modules/linux.eselect"
}
