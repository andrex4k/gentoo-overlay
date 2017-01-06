# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit autotools eutils

DESCRIPTION="Modern graphical system monitor for any panel"
HOMEPAGE="https://github.com/udda/multiload-ng"

SRC_URI="https://github.com/udda/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="amd64 x86"

LICENSE="GPL-2"
SLOT="0"
IUSE="-debug -experimental gtk2 +gtk3 -indicator +lxde +mate +standalone -systray +xfce4"

LANGS="de es fr it lt ru zh_CN"
for lang in ${LANGS} ; do IUSE+=" linguas_${lang}"; done

RDEPEND="
	gtk2? ( >=x11-libs/gtk+-2.20:2 )
	gtk3? ( x11-libs/gtk+:3 )
	x11-libs/cairo:=
	indicator? (
		gtk2? ( >=dev-libs/libappindicator-0.4.92:2 )
		gtk3? ( >=dev-libs/libappindicator-0.4.92:3 )
	)
	lxde? (
		>=lxde-base/lxpanel-0.7.0
		>=x11-libs/libfm-1.2.0
	)
	mate? (
		gtk2? ( >=mate-base/mate-panel-1.7.0 )
		gtk3? ( >=mate-base/mate-panel-1.7.0[gtk3(-)] )
	)
	xfce4? (
		gtk2? (
			>=xfce-base/libxfce4util-4.6.0
			>=xfce-base/xfce4-panel-4.6.0
		)
		gtk3? (
			>=xfce-base/libxfce4util-4.12.0
			>=xfce-base/xfce4-panel-4.12.0
		)
	)"

DEPEND="${RDEPEND}
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig"

DOCS="AUTHORS README.md"

REQUIRED_USE="
	^^ ( gtk2 gtk3 )
	|| ( indicator lxde mate standalone systray xfce4 )
	indicator? ( experimental )
	systray? ( experimental )
	lxde? ( gtk2 )"

src_prepare() {
	eautoreconf
	eapply_user
}

src_configure() {
	if use gtk2; then
		GTK_CONF="--with-gtk=2.0"
	else
		GTK_CONF="--with-gtk=3.0 --disable-deprecations"
	fi
	econf \
		$(use_enable experimental) \
		$(use_enable debug) \
		$GTK_CONF \
		$(use_with standalone) \
		$(use_with lxde lxpanel) \
		$(use_with mate) \
		$(use_with systray) \
		$(use_with xfce4)

	if use experimental; then
		elog "You are enabling experimental code. Please note that this can be really unstable."
	fi
}
