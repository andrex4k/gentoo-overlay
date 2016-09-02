# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

AUTOTOOLS_AUTORECONF=1

PLOCALES="ar bg ca cs da de el en en_US eo es fa fi fr he hi hr hu it ja ko lt ml nb_NO nl or pa pl pt_BR pt_PT rm ro ru sk sl sr_RS@cyrillic sr_RS@latin sv te th tr uk wa zh_CN zh_TW"
PLOCALE_BACKUP="en"

GV="2.36"
MV="4.5.6"
MY_P="${PN}-${PV/_/-}"

inherit autotools-utils eutils fdo-mime flag-o-matic gnome2-utils l10n multilib multilib-minimal pax-utils toolchain-funcs virtualx

DESCRIPTION="Free implementation of Windows(tm) on Unix"
HOMEPAGE="http://www.winehq.org/"
SRC_URI="mirror://sourceforge/${PN}/Source/${MY_P}.tar.bz2
	gecko? (
		abi_x86_32? ( mirror://sourceforge/${PN}/Wine%20Gecko/${GV}/wine_gecko-${GV}-x86.msi )
		abi_x86_64? ( mirror://sourceforge/${PN}/Wine%20Gecko/${GV}/wine_gecko-${GV}-x86_64.msi )
	)

	mono? ( mirror://sourceforge/${PN}/Wine%20Mono/${MV}/wine-mono-${MV}.msi )
"

LICENSE="LGPL-2.1"
SLOT="${PV}"
KEYWORDS="~amd64 ~x86"

IUSE="+abi_x86_32 +abi_x86_64 +alsa capi cups custom-cflags dos elibc_glibc +fontconfig +gecko gphoto2 gsm gstreamer +jpeg lcms ldap +mono mp3 ncurses netapi nls odbc openal opencl +opengl osmesa oss pcap +perl +png +prelink +realtime +run-exes samba scanner selinux +ssl test +threads +truetype +udisks v4l +X xcomposite xinerama +xml"
REQUIRED_USE="|| ( abi_x86_32 abi_x86_64 )
	elibc_glibc? ( threads )

	mono? ( abi_x86_32 )

	osmesa? ( opengl )

	test? ( abi_x86_32 )
"

# The test suite is unsuitable for us; many tests require net access
# or fail due to Xvfb's opengl limitations.
RESTRICT="test"

COMMON_DEPEND="
	capi? ( net-dialup/capi4k-utils )

	fontconfig? ( media-libs/fontconfig:=[${MULTILIB_USEDEP}] )

	ncurses? ( >=sys-libs/ncurses-5.2:0=[${MULTILIB_USEDEP}] )

	truetype? ( >=media-libs/freetype-2.0.0[${MULTILIB_USEDEP}] )

	udisks? ( sys-apps/dbus[${MULTILIB_USEDEP}] )

	gphoto2? ( media-libs/libgphoto2:=[${MULTILIB_USEDEP}] )

	openal? ( media-libs/openal:=[${MULTILIB_USEDEP}] )

	gstreamer? (
		media-libs/gstreamer:0.10[${MULTILIB_USEDEP}]
		media-libs/gst-plugins-base:0.10[${MULTILIB_USEDEP}]
	)

	X? (
		x11-libs/libXcursor[${MULTILIB_USEDEP}]
		x11-libs/libXext[${MULTILIB_USEDEP}]
		x11-libs/libXrandr[${MULTILIB_USEDEP}]
		x11-libs/libXi[${MULTILIB_USEDEP}]
		x11-libs/libXxf86vm[${MULTILIB_USEDEP}]
	)

	xinerama? ( x11-libs/libXinerama[${MULTILIB_USEDEP}] )

	alsa? ( media-libs/alsa-lib[${MULTILIB_USEDEP}] )

	cups? ( net-print/cups:=[${MULTILIB_USEDEP}] )

	opencl? ( virtual/opencl[${MULTILIB_USEDEP}] )

	opengl? (
		virtual/glu[${MULTILIB_USEDEP}]
		virtual/opengl[${MULTILIB_USEDEP}]
	)

	gsm? ( media-sound/gsm:=[${MULTILIB_USEDEP}] )

	jpeg? ( virtual/jpeg:0=[${MULTILIB_USEDEP}] )

	ldap? ( net-nds/openldap:=[${MULTILIB_USEDEP}] )

	lcms? ( media-libs/lcms:2=[${MULTILIB_USEDEP}] )

	mp3? ( >=media-sound/mpg123-1.5.0[${MULTILIB_USEDEP}] )

	netapi? ( net-fs/samba[netapi(+),${MULTILIB_USEDEP}] )

	nls? ( sys-devel/gettext[${MULTILIB_USEDEP}] )

	odbc? ( dev-db/unixODBC:=[${MULTILIB_USEDEP}] )

	osmesa? ( media-libs/mesa[osmesa,${MULTILIB_USEDEP}] )

	pcap? ( net-libs/libpcap[${MULTILIB_USEDEP}] )

	xml? (
		dev-libs/libxml2[${MULTILIB_USEDEP}]
		dev-libs/libxslt[${MULTILIB_USEDEP}]
	)

	scanner? ( media-gfx/sane-backends:=[${MULTILIB_USEDEP}] )

	ssl? ( net-libs/gnutls:=[${MULTILIB_USEDEP}] )

	png? ( media-libs/libpng:0=[${MULTILIB_USEDEP}] )

	v4l? ( media-libs/libv4l[${MULTILIB_USEDEP}] )

	xcomposite? ( x11-libs/libXcomposite[${MULTILIB_USEDEP}] )

	abi_x86_32? (
		!app-emulation/emul-linux-x86-baselibs[-abi_x86_32(-)]
		!<app-emulation/emul-linux-x86-baselibs-20140508-r14
		!app-emulation/emul-linux-x86-db[-abi_x86_32(-)]
		!<app-emulation/emul-linux-x86-db-20140508-r3
		!app-emulation/emul-linux-x86-medialibs[-abi_x86_32(-)]
		!<app-emulation/emul-linux-x86-medialibs-20140508-r6
		!app-emulation/emul-linux-x86-opengl[-abi_x86_32(-)]
		!<app-emulation/emul-linux-x86-opengl-20140508-r1
		!app-emulation/emul-linux-x86-sdl[-abi_x86_32(-)]
		!<app-emulation/emul-linux-x86-sdl-20140508-r1
		!app-emulation/emul-linux-x86-soundlibs[-abi_x86_32(-)]
		!<app-emulation/emul-linux-x86-soundlibs-20140508
		!app-emulation/emul-linux-x86-xlibs[-abi_x86_32(-)]
		!<app-emulation/emul-linux-x86-xlibs-20140508
	)"

RDEPEND="${COMMON_DEPEND}
	app-admin/eselect-wine

	dos? ( games-emulation/dosbox )

	perl? (
		dev-lang/perl
		dev-perl/XML-Simple
	)

	samba? ( >=net-fs/samba-3.0.25 )

	selinux? ( sec-policy/selinux-wine )

	udisks? ( sys-fs/udisks:2 )
"

# tools/make_requests requires perl
DEPEND="${COMMON_DEPEND}
	dev-lang/perl

	dev-perl/XML-Simple

	X? (
		x11-proto/inputproto
		x11-proto/xextproto
		x11-proto/xf86vidmodeproto
	)

	xinerama? ( x11-proto/xineramaproto )

	prelink? ( sys-devel/prelink )

	>=sys-kernel/linux-headers-3.0

	virtual/pkgconfig

	virtual/yacc

	sys-devel/flex
"

# These use a non-standard "Wine" category, which is provided by
# /etc/xdg/applications-merged/wine.menu
QA_DESKTOP_FILE="
usr/share/applications/wine-browsedrive.desktop
usr/share/applications/wine-notepad.desktop
usr/share/applications/wine-uninstaller.desktop
usr/share/applications/wine-winecfg.desktop
"

S=${WORKDIR}/${MY_P}

PREFIX="/usr/lib/wine/${PV}"

wine_build_environment_check() {
	[[ ${MERGE_TYPE} = "binary" ]] && return 0

	if use abi_x86_64 && [[ $(( $(gcc-major-version) * 100 + $(gcc-minor-version) )) -lt 404 ]]; then
		eerror "You need gcc-4.4+ to build 64-bit wine"
		eerror
		return 1
	fi

	if use abi_x86_32 && use opencl && [[ x$(eselect opencl show 2> /dev/null) = "xintel" ]]; then
		eerror "You cannot build wine with USE=opencl because intel-ocl-sdk is 64-bit only."
		eerror "See https://bugs.gentoo.org/487864 for more details."
		eerror
		return 1
	fi
}

pkg_pretend() {
	wine_build_environment_check || die
}

pkg_setup() {
	wine_build_environment_check || die
}

src_unpack() {
	unpack ${MY_P}.tar.bz2

	l10n_find_plocales_changes "${S}/po" "" ".po"
}

src_prepare() {
	local PATCHES=(
		"${FILESDIR}"/${PN}-1.5.26-winegcc.patch #260726
		"${FILESDIR}"/${PN}-1.4_rc2-multilib-portage.patch #395615
		"${FILESDIR}"/${PN}-1.7.2-osmesa-check.patch #429386
		"${FILESDIR}"/${PN}-1.6-memset-O3.patch #480508
	)

	autotools-utils_src_prepare

	#sed -i '/^UPDATE_DESKTOP_DATABASE/s:=.*:=true:' tools/Makefile.in || die

	if ! use run-exes; then
		sed -i '/^MimeType/d' tools/wine.desktop || die #117785
	fi

	l10n_get_locales > po/LINGUAS # otherwise wine doesn't respect LINGUAS
}

src_configure() {
	export LDCONFIG=/bin/true
	use custom-cflags || strip-flags

	multilib-minimal_src_configure
}

multilib_src_configure() {
	local myconf=(
		--prefix=/usr/lib/wine/${PV}
		--sysconfdir=/etc/wine/${PV}
		--datarootdir=/usr/lib/wine/${PV}
		--datadir=/usr/lib/wine/${PV}/share
		--mandir=/usr/lib/wine/${PV}/share/man
		--without-hal
		$(use_enable test tests)
		$(use_with alsa)
		$(use_with capi)
		$(use_with lcms cms)
		$(use_with cups)
		$(use_with ncurses curses)
		$(use_with udisks dbus)
		$(use_with fontconfig)
		$(use_with ssl gnutls)
		$(use_with gphoto2 gphoto)
		$(use_with gsm)
		$(use_with gstreamer)
		$(use_with jpeg)
		$(use_with ldap)
		$(use_with mp3 mpg123)
		$(use_with netapi)
		$(use_with nls gettext)
		$(use_with openal)
		$(use_with opencl)
		$(use_with opengl)
		$(use_with osmesa)
		$(use_with oss)
		$(use_with png)
		$(use_with threads pthread)
		$(use_with scanner sane)
		$(use_with truetype freetype)
		$(use_with v4l)
		$(use_with X x)
		$(use_with xcomposite)
		$(use_with xinerama)
		$(use_with xml)
		$(use_with xml xslt)
	)

	local PKG_CONFIG AR RANLIB
	# Avoid crossdev's i686-pc-linux-gnu-pkg-config if building wine32 on amd64; #472038
	# set AR and RANLIB to make QA scripts happy; #483342
	tc-export PKG_CONFIG AR RANLIB

	if use amd64; then
		if [[ ${ABI} == amd64 ]]; then
			myconf+=( --enable-win64 )
		else
			myconf+=( --disable-win64 )
		fi

		# Note: using --with-wine64 results in problems with multilib.eclass
		# CC/LD hackery. We're using separate tools instead.
	fi

	ECONF_SOURCE=${S} \
	econf "${myconf[@]}"

	emake depend
}

multilib_src_test() {
	# FIXME: win32-only; wine64 tests fail with "could not find the Wine loader"
	if [[ ${ABI} == x86 ]]; then
		if [[ $(id -u) == 0 ]]; then
			ewarn "Skipping tests since they cannot be run under the root user."
			ewarn "To run the test ${PN} suite, add userpriv to FEATURES in make.conf"
			return
		fi

		WINEPREFIX="${T}/.wine-${ABI}" \
		Xemake test
	fi
}

multilib_src_install_all() {
	local l

	prune_libtool_files --all

	if use gecko ; then
		insinto /usr/lib/wine/${PV}/share/wine/gecko
		use abi_x86_32 && doins "${DISTDIR}"/wine_gecko-${GV}-x86.msi
		use abi_x86_64 && doins "${DISTDIR}"/wine_gecko-${GV}-x86_64.msi
	fi

	if use mono ; then
		insinto /usr/lib/wine/${PV}/share/wine/mono
		doins "${DISTDIR}"/wine-mono-${MV}.msi
	fi

	if ! use perl ; then
		rm "${D}"/usr/lib/wine/${PV}/bin/{wine{dump,maker},function_grep.pl} || die
		rm "${D}"/usr/lib/wine/${PV}/share/man/man1/wine{dump,maker}.1 || die
	fi

	use abi_x86_32 && pax-mark psmr "${D}"/usr/lib/wine/${PV}/bin/wine{,-preloader} #255055
	use abi_x86_64 && pax-mark psmr "${D}"/usr/lib/wine/${PV}/bin/wine64{,-preloader}

	if use abi_x86_64 && ! use abi_x86_32; then
		dosym "${D}"/usr/lib/wine/${PV}/bin/wine{64,} # 404331
		dosym "${D}"/usr/lib/wine/${PV}/bin/wine{64,}-preloader
	fi

	# respect LINGUAS when installing man pages, #469418
	for l in de fr pl; do
		use linguas_${l} || rm -r "${D}"/usr/lib/wine/${PV}/share/man/${l}*
	done
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
	fdo-mime_desktop_database_update
}

pkg_postrm() {
	gnome2_icon_cache_update
	fdo-mime_desktop_database_update
}
