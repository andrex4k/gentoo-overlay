# Distributed under the terms of the GNU General Public License v2
# $Header: $
EAPI=4
DESCRIPTION="Clonezilla is a partition and disk imaging/cloning program similar to True Image® or Norton Ghost®"

SRC_URI="http://free.nchc.org.tw/drbl-core/src/testing/${PN}-${PV}.tar.bz2"
SLOT="0"
LICENSE="GPL3"
KEYWORDS="~x86 ~amd64"
DEPEND="sys-block/drbl
	sys-fs/cloudfuse
	sys-block/partclone"
RDEPEND="${DEPEND}"

src_install() {
	emake install DESTDIR="${D}"
}
