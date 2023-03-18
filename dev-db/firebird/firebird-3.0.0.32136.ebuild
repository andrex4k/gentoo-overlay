# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=8

inherit autotools eutils flag-o-matic multilib systemd user versionator

MY_P="${PN/f/F}-${PV}-ReleaseCandidate1"

DESCRIPTION="A relational database offering many ANSI SQL:2003 and some SQL:2008 features"
HOMEPAGE="http://www.firebirdsql.org/"
SRC_URI="mirror://sourceforge/firebird/${MY_P}.tar.bz2"

LICENSE="IDPL Interbase-1.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="debug doc examples systemd"

REQUIRED_USE=""

CDEPEND="
	dev-libs/icu:=
	dev-libs/libedit:=
	dev-libs/libtommath:=
"

DEPEND="${CDEPEND}
	dev-util/btyacc
"

RDEPEND="${CDEPEND}
	!sys-cluster/ganglia

	systemd? (
		sys-apps/systemd
	)
"

RESTRICT="userpriv"

S="${WORKDIR}/${MY_P}"

pkg_setup() {
	enewgroup firebird 450
	enewuser firebird 450 /bin/bash /var/lib/firebird firebird
}

src_configure() {
	econf \
		--prefix=/usr/$(get_libdir)/firebird \
		--enable-shared=yes \
		--enable-static=no \
		--with-editline \
		--with-system-editline \
		--with-system-icu \
		--with-fbbin=/usr/bin \
		--with-fbsbin=/usr/bin \
		--with-fbconf=/etc/firebird \
		--with-fblib=/usr/$(get_libdir) \
		--with-fbinclude=/usr/include \
		--with-fbdoc=/usr/share/doc/firebird \
		--with-fbudf=/usr/$(get_libdir)/firebird/udf \
		--with-fbsample=/usr/share/doc/${P}/examples \
		--with-fbsample-db=/usr/share/doc/${P}/examples/db \
		--with-fbhelp=/usr/$(get_libdir)/firebird/help \
		--with-fbintl=/usr/$(get_libdir)/firebird/intl \
		--with-fbmisc=/usr/share/firebird \
		--with-fbsecure-db=/etc/firebird \
		--with-fbmsg=/usr/$(get_libdir)/firebird \
		--with-fblog=/var/log/firebird \
		--with-fbglock=/var/run/firebird \
		--with-fbplugins=/usr/$(get_libdir)/firebird/plugins \
		--with-gnu-ld \
		$(use_enable debug) \
		${myconf}
}

src_install() {
	cd "gen/Release/firebird" || die

	insinto /etc/firebird
	doins *.conf
	doins intl/fbintl.conf
	doins plugins/udr_engine.conf

	# Default binary name isql used in other databases like postgresql.
	newbin bin/isql fbsql

	local bins="fb_lock_print fbguard fbsvcmgr fbtracemgr firebird gbak gfix gsec gsplit gstat nbackup qli"
	for bin in ${bins}; do
		dobin bin/${bin}
	done

	doheader -r include/*

	insinto /usr/$(get_libdir)
	dolib.so lib/*.so*

	insinto /usr/$(get_libdir)/firebird
	doins firebird.msg

	insinto /usr/$(get_libdir)/firebird/help
	doins help/help.fdb

	insinto /usr/$(get_libdir)/firebird/intl
	dosym /etc/firebird/fbintl.conf /usr/$(get_libdir)/firebird/intl/fbintl.conf

	exeinto /usr/$(get_libdir)/firebird/intl
	doexe intl/libfbintl.so

	insinto /usr/$(get_libdir)/firebird/plugins
	dosym /etc/firebird/udr_engine.conf /usr/$(get_libdir)/firebird/plugins/udr_engine.conf

	exeinto /usr/$(get_libdir)/firebird/plugins
	doexe plugins/*.so

	exeinto /usr/$(get_libdir)/firebird/udf
	doexe UDF/*.so

	diropts -m 750 -o firebird -g firebird
	dodir /var/{lib,log}/firebird
	keepdir /var/{lib,log}/firebird

	if use doc; then
		dodoc "${S}"/doc/*.pdf
	fi

	if use systemd; then
		systemd_dounit "${FILESDIR}/firebird-superserver.service"
		systemd_dounit "${FILESDIR}/firebird-classic@.service"
		systemd_dounit "${FILESDIR}/firebird-classic.socket"
		systemd_newtmpfilesd "${FILESDIR}/firebird.tmpfiles" "firebird.conf"
	fi
}

pkg_postinst() {
	# Hack to fix ownership/perms.
	chown -f -R firebird:firebird "${ROOT}/etc/firebird"
	chmod 755 "${ROOT}/etc/firebird"
}

pkg_config() {
	einfo "If you're using UDFs, please remember to move them"
	einfo "to /usr/lib/firebird/udf"
}
