# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

# emacs support disabled due to #99533 #335900

EAPI="4"

inherit eutils systemd toolchain-funcs autotools

DESCRIPTION="Console-based mouse driver"
HOMEPAGE="http://www.nico.schottelius.org/software/gpm/"
SRC_URI="http://www.nico.schottelius.org/software/${PN}/archives/${P}.tar.lzma"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="selinux static-libs"

RDEPEND="sys-libs/ncurses
	selinux? ( sec-policy/selinux-gpm )"
DEPEND="sys-libs/ncurses
	app-arch/xz-utils
	virtual/yacc"

src_prepare() {
	# fix ABI values
	sed -i \
		-e '/^abi_lev=/s:=.*:=1:' \
		-e '/^abi_age=/s:=.*:=20:' \
		configure.ac.footer || die
	sed -i -e '/ACLOCAL/,$d' autogen.sh || die
	./autogen.sh
	eautoreconf
}

src_configure() {
	econf \
		--sysconfdir=/etc/gpm \
		$(use_enable static-libs static) \
		emacs=/bin/false
}

src_compile() {
	# make sure nothing compiled is left
	emake clean
	emake EMACS=:
}

src_install() {
	emake install DESTDIR="${D}" EMACS=: ELISP=""

	dosym libgpm.so.1 /usr/$(get_libdir)/libgpm.so
	multilib_is_native_abi && gen_usr_ldscript -a gpm

	insinto /etc/gpm
	doins conf/gpm-*.conf

	dodoc README TODO
	dodoc doc/Announce doc/FAQ doc/README*

	newinitd "${FILESDIR}"/gpm.rc6-2 gpm
	newconfd "${FILESDIR}"/gpm.conf.d gpm
	systemd_dounit "${FILESDIR}"/gpm.service
}
