# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit eutils gnome2-utils systemd

DESCRIPTION="OpenTTD is a clone of Transport Tycoon Deluxe"
HOMEPAGE="http://www.openttd.org/"
SRC_URI="http://binaries.openttd.org/releases/${PV}/${P}-source.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"

IUSE="aplaymidi debug dedicated iconv icu lzo +openmedia +png sse systemd +timidity +truetype zlib"

RESTRICT="test" # needs a graphics set in order to test

DEPEND="
	!dedicated? (
		media-libs/libsdl[X,sound,video]

		icu? ( dev-libs/icu:= )

		truetype? (
			media-libs/fontconfig
			media-libs/freetype:2
			sys-libs/zlib
		)
	)

	iconv? ( virtual/libiconv )
	lzo? ( dev-libs/lzo:2 )
	png? ( media-libs/libpng:* )
	systemd? ( sys-apps/systemd )
	zlib? ( sys-libs/zlib )
"

RDEPEND="${DEPEND}"

PDEPEND="
	!dedicated? (
		openmedia? (
			games-misc/openmsx
			games-misc/opensfx
		)

		aplaymidi? ( media-sound/alsa-utils )
		!aplaymidi? ( timidity? ( media-sound/timidity++ ) )
	)

	openmedia? ( games-misc/opengfx )
"

pkg_setup() {
	if use dedicated ; then
		enewgroup gamestat 36
		enewuser openttd -1 -1 /var/lib/openttd gamestat
	fi
}

src_prepare() {
	default

	sed -i \
	    -e '/Keywords/s/$/;/' \
	    media/openttd.desktop.in || die
}

src_configure() {
	local myopts=""

	# There is an allegro interface available as well as sdl, but
	# the configure for it looks broken so the sdl interface is
	# always built instead.
	myopts+=" --without-allegro"

	# Libtimidity not needed except for some embedded platform
	# nevertheless, it will be automagically linked if it is
	# installed. Hence, we disable it.
	myopts+=" --without-libtimidity"

	use debug && myopts+=" --enable-debug=3"

	if use dedicated ; then
		myopts+=" --binary-name=openttd-dedicated --enable-dedicated"
	else
		use aplaymidi && myopts+=" --with-midi='${EPREFIX}/usr/bin/aplaymidi'"

		myopts+="
		    $(use_with truetype freetype)
		    $(use_with icu)
		    --with-sdl"
	fi

	if use png || { use !dedicated && use truetype; } || use zlib ; then
		myopts+=" --with-zlib"
	else
		myopts+=" --without-zlib"
	fi

	# Configure is a hand-written bash-script, so econf will not work.
	# It's all built as C++, upstream uses CFLAGS internally.
	./configure \
	    --prefix-dir="${EPREFIX}" \
	    --binary-dir="/usr/bin" \
	    --data-dir="/usr/share/openttd" \
	    --install-dir="${D}" \
	    --icon-dir="/usr/share/pixmaps" \
	    --menu-dir="/usr/share/applications" \
	    --icon-theme-dir="/usr/share/icons/hicolor" \
	    --man-dir="/usr/share/man/man6" \
	    --doc-dir="/usr/share/doc/openttd" \
	    --menu-group="Game;Simulation;" \
	    --disable-strip \
	    ${myopts} \
	    $(use_with iconv) \
	    $(use_with png) \
	    $(use_with sse) \
	    $(use_with lzo liblzo2) \
	    || die
}

src_compile() {
	emake VERBOSE=1
}

src_install() {
	emake DESTDIR="${D}" install

	if use dedicated ; then
		if use systemd ; then
			systemd_newunit "${FILESDIR}/systemd/openttd.service" "openttd@.service"
		fi

		rm -rf "${ED}"/usr/share/{applications,icons,pixmaps}
	fi

	rm -f "${ED}"/usr/share/doc/${PF}/COPYING
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update

	if use dedicated ; then
		ewarn "About openttd dedicated read here:"
		ewarn "https://wiki.openttd.org/Dedicated_server"
		ewarn "https://wiki.openttd.org/Openttd.cfg"

		if use systemd ; then
			ewarn "Systemd unit for server instances: openttd@.service"
			ewarn "All server configs and files placed here /var/lib/games/openttd"
			ewarn "If you dont have config run and stop server once."
			ewarn "Example: systemctl start openttd@main (uses config server-main.cfg)."
		fi
	else
		if use aplaymidi ; then
			elog "You have emerged with 'aplaymidi' for playing MIDI."
			elog "This option is for those with a hardware midi device,"
			elog "or who have set up ALSA to handle midi ports."
			elog "You must set the environment variable ALSA_OUTPUT_PORTS."
			elog "Available ports can be listed by using 'aplaymidi -l'."
		else
			if ! use timidity ; then
				elog "OpenTTD was built with neither 'aplaymidi' nor 'timidity'"
				elog "in USE. Music may or may not work in-game. If you happen"
				elog "to have timidity++ installed, music will work so long"
				elog "as it remains installed, but OpenTTD will not depend on it."
			fi
		fi
		if ! use openmedia ; then
			elog
			elog "OpenTTD was compiled without the 'openmedia' USE flag."
			elog
			elog "In order to play, you must at least install:"
			elog "games-misc/opengfx, and games-misc/opensfx, or copy the "
			elog "following 6 files from a version of Transport Tycoon Deluxe"
			elog "(windows or DOS) to ~/.openttd/data/ or"
			elog "${EPREFIX}/usr/share/openttd/data/."
			elog
			elog "From the WINDOWS version you need: "
			elog "sample.cat trg1r.grf trgcr.grf trghr.grf trgir.grf trgtr.grf"
			elog "OR from the DOS version you need: "
			elog "SAMPLE.CAT TRG1.GRF TRGC.GRF TRGH.GRF TRGI.GRF TRGT.GRF"
			elog
			elog "File names are case sensitive, but should work either with"
			elog "all upper or all lower case names"
			elog
			elog "In addition, in-game music will be unavailable: for music,"
			elog "install games-misc/openmsx, or use the in-game download"
			elog "functionality to get a music set"
			elog
		fi
	fi

	if ! use lzo ; then
		elog "OpenTTD was built without 'lzo' in USE. While 'lzo' is not"
		elog "required, disabling it does mean that loading old savegames"
		elog "or scenarios from ancient versions (~0.2) will fail."
		elog
	fi
}

pkg_postrm() {
	gnome2_icon_cache_update
}
