# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit eutils systemd user

DESCRIPTION="The atheme project's IRCd based on ratbox"
HOMEPAGE="http://atheme.org/project/charybdis http://www.stack.nl/~jilles/irc/#charybdis"
SRC_URI="http://distfiles.charybdis.io/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="debug +ipv6 largenet ssl systemd zlib"

RDEPEND="
	ssl? ( dev-libs/openssl )

	systemd? ( sys-apps/systemd )

	zlib? ( sys-libs/zlib )
"

DEPEND="${RDEPEND}
	sys-devel/flex

	virtual/yacc
"

pkg_setup() {
	enewgroup charybdis
	enewuser charybdis -1 -1 /var/lib/charybdis charybdis
}

src_configure() {
	local myopts=(
		--sysconfdir="/etc/charybdis"
		--libdir="/usr/$(get_libdir)/charybdis"
		--with-logdir="/var/log/charybdis"
		--with-moduledir="/usr/$(get_libdir)/charybdis/modules"
		--with-rundir="/var/run"
		--with-program-prefix="charybdis-"
		--enable-fhs-paths
		$(use_enable debug assert soft)
		$(use_enable debug iodebug)
		$(use_enable ipv6)
		$(use_enable !largenet small-net)
		$(use_enable ssl openssl)
		$(use_enable zlib)
	)

	econf ${myopts[@]}
}

src_install() {
	default

	insinto /etc/charybdis
	newins doc/reference.conf ircd.conf

	keepdir /var/{lib,log}/charybdis

	# Ensure that if `make install' created /var/run/charybdis, we still
	# force the initscript to create that directory.
	rm -rf "${D}"/var/run || die

	# Charybdis ircd needs writing to its state (bandb) and log directories.
	fowners :charybdis /var/{lib,log}/charybdis
	fperms 770 /var/{lib,log}/charybdis

	# Ensure that charybdis can access but not modify its configuration
	# while protecting it from others.
	fowners :charybdis /etc/charybdis{,/ircd.conf}
	fperms 750 /etc/charybdis
	fperms 640 /etc/charybdis/ircd.conf

	if use systemd; then
		systemd_dounit "${FILESDIR}"/systemd/charybdis.service
		systemd_newtmpfilesd "${FILESDIR}"/systemd/charybdis.tmpfiles charybdis.conf
	fi
}

pkg_postinst() {
	elog "All of the charybdis binaries in PATH have been prefixed with"
	elog "'charybdis-' to prevent file collisions."
}
