# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit autotools eutils toolchain-funcs flag-o-matic systemd

DESCRIPTION="Rotates, compresses, and mails system logs"
HOMEPAGE="https://fedorahosted.org/logrotate/"
SRC_URI="https://github.com/logrotate/logrotate/archive/${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE="acl cron selinux systemd"

CDEPEND="
	>=dev-libs/popt-1.5

	acl? ( virtual/acl )
	cron? ( virtual/cron )
	selinux? ( sys-libs/libselinux )
	systemd? ( sys-apps/systemd )
"

DEPEND="${CDEPEND}
	>=sys-apps/sed-4
"

RDEPEND="${CDEPEND}
	selinux? ( sec-policy/selinux-logrotate )
"

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-ignore-hidden.patch \
		"${FILESDIR}"/${P}-fbsd.patch \
		"${FILESDIR}"/${P}-noasprintf.patch \
		"${FILESDIR}"/${P}-atomic-create.patch \
		"${FILESDIR}"/${P}-Werror.patch
	eautoreconf
}

src_configure() {
	econf $(use_with acl) $(use_with selinux)
}

src_compile() {
	emake ${myconf} RPM_OPT_FLAGS="${CFLAGS}"
}

src_test() {
	emake test
}

src_install() {
	insinto /usr
	dosbin logrotate
	doman logrotate.8
	dodoc CHANGES examples/logrotate*

	insinto /etc
	doins "${FILESDIR}"/logrotate.conf

	keepdir /etc/logrotate.d

	if use cron ; then
		exeinto /etc/cron.daily
		newexe "${S}"/examples/logrotate.cron "${PN}"
	fi

	if use systemd ; then
		systemd_dounit "${FILESDIR}/systemd/logrotate.service"
		systemd_dounit "${FILESDIR}/systemd/logrotate.timer"
	fi
}

pkg_postinst() {
	if [[ -z ${REPLACING_VERSIONS} ]] ; then
		elog "If you wish to have logrotate e-mail you updates, please"
		elog "emerge virtual/mailx and configure logrotate in"
		elog "/etc/logrotate.conf appropriately"
		elog
		elog "Additionally, /etc/logrotate.conf may need to be modified"
		elog "for your particular needs.  See man logrotate for details."
	fi
}
