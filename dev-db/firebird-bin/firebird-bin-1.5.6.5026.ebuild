# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="6"

inherit eutils systemd user

DESCRIPTION="A relational database offering many ANSI SQL:2003 and some SQL:2008 features"
HOMEPAGE="http://www.firebirdsql.org/"
SRC_URI="http://planetexpress.ddnsking.com:9080/files/gentoo/distfiles/${P}.tar.xz"

LICENSE="IDPL Interbase-1.0"
SLOT="0"
KEYWORDS="~x86"

IUSE="systemd"

REQUIRED_USE=""

RESTRICT="strip"

RDEPEND="
	!sys-cluster/ganglia

	virtual/libstdc++

	systemd? (
		sys-apps/systemd
	)
"

pkg_setup() {
	enewgroup firebird 450
	enewuser firebird 450 /bin/bash /var/lib/firebird firebird
}

src_install() {
	dodir /opt
	mv "${S}"/opt/* "${D}"/opt || die

	insinto /etc/env.d
	doins "${FILESDIR}"/90firebird

	# Make sure everything is owned by firebird.
	chown -R firebird:firebird "${D}"/opt/firebird || die

	if use systemd; then
		systemd_dounit "${FILESDIR}/firebird-superserver.service"
		systemd_dounit "${FILESDIR}/firebird-classic@.service"
		systemd_dounit "${FILESDIR}/firebird-classic.socket"
	fi
}

pkg_postinst() {
	# Make sure everything is owned by firebird.
	chown firebird:firebird /var/lib/firebird || die

	elog "If haven't done so already, please run:"
	elog
	elog "  emerge --config =${PF}"
	elog
	elog "to create lockfiles, set permissions and more."
	elog
	elog "Firebird now runs with it's own user. Please remember to"
	elog "set permissions to firebird:firebird on databases you"
	elog "already have (if any)."
	elog
	elog "If you're using UDFs, please remember to move them"
	elog "to /opt/firebird/UDF"
	elog

	ewarn
	ewarn "Lock files, logs, configs and other stuff placed in /opt/firebird"
	ewarn "Say thanks to firebird team."
}

pkg_config() {
	# We need to enable local access to the server.
	if [[ ! -f /etc/hosts.equiv ]]; then
		touch /etc/hosts.equiv
	fi

	if [[ -z "$(grep 'localhost$' /etc/hosts.equiv)" ]]; then
		echo "localhost" >> /etc/hosts.equiv
		einfo "Added localhost to /etc/hosts.equiv"
	fi

	HS_NAME=$(hostname)
	if [[ -z "$(grep ${HS_NAME} /etc/hosts.equiv)" ]]; then
		echo "${HS_NAME}" >> /etc/hosts.equiv
		einfo "Added ${HS_NAME} to /etc/hosts.equiv"
	fi
}
