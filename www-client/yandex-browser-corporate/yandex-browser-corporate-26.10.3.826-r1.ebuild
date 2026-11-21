# Copyright 2026
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Chromium revision this build is based on (see opt/yandex/browser/update-ffmpeg),
# also used as the slot of media-video/ffmpeg-chromium.
CHROMIUM_VERSION="152"

CHROMIUM_LANGS="
	cs
	de
	en-US
	es
	fr
	it
	ja
	kk
	pt-BR
	pt-PT
	ru
	tr
	uk
	uz
	zh-CN
	zh-TW
"

inherit chromium-2 desktop linux-info pax-utils unpacker xdg

DESCRIPTION="The web browser from Yandex (corporate edition)"
HOMEPAGE="https://browser.yandex.ru/"
LICENSE="Yandex-EULA"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+ffmpeg-codecs qt6"
RESTRICT="bindist mirror strip"

# Upstream names the file with the full four-component version and "-1".
MY_PV="${PV/_p/-}"
SRC_URI="https://repo.yandex.ru/yandex-browser/deb/pool/main/y/${PN}/${PN}_${MY_PV}-1_amd64.deb -> ${P}.deb"

RDEPEND="
	app-accessibility/at-spi2-core
	app-misc/ca-certificates
	dev-libs/expat
	dev-libs/glib:2
	dev-libs/nspr
	dev-libs/nss
	media-fonts/liberation-fonts
	media-libs/alsa-lib
	media-libs/fontconfig
	media-libs/freetype
	media-libs/mesa[opengl]
	media-libs/vulkan-loader
	net-print/cups
	sys-apps/dbus
	sys-fs/squashfs-tools
	virtual/libudev
	x11-libs/cairo
	x11-libs/gtk+:3
	x11-libs/libX11
	x11-libs/libXcomposite
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXrandr
	x11-libs/libxcb
	x11-libs/libxkbcommon
	x11-libs/pango
	x11-misc/xdg-utils
	ffmpeg-codecs? ( media-video/ffmpeg-chromium:${CHROMIUM_VERSION} )
	qt6? ( dev-qt/qtbase:6[gui,widgets] )
"

QA_PREBUILT="*"

S="${WORKDIR}"
YANDEX_HOME="opt/yandex/browser"

pkg_setup() {
	chromium_suid_sandbox_check_kernel_config
}

src_unpack() {
	unpack_deb ${A}
}

src_prepare() {
	# The Debian package ships its own cron hook, an autostart entry and an
	# ffmpeg downloader that all write outside the package manager.
	rm -r etc || die
	rm -r "${YANDEX_HOME}/cron" || die
	rm -f "${YANDEX_HOME}/update-ffmpeg" || die

	# Portage compresses man pages and docs itself; shipping pre-compressed
	# files triggers QA notices.
	gunzip "usr/share/man/man1/${PN}.1.gz" || die
	rm -f "usr/share/man/man1/yandex-browser.1.gz" || die
	# Keep the short-name alias as a real file: Portage's compression
	# extension (gz/bz2/xz) is profile-dependent, a symlink would break.
	cp "usr/share/man/man1/${PN}.1" "usr/share/man/man1/yandex-browser.1" || die
	gunzip "usr/share/doc/${PN}/changelog.gz" || die

	mv "usr/share/doc/${PN}" "usr/share/doc/${PF}" || die

	mkdir -p usr/share/metainfo || die
	mv usr/share/appdata/* usr/share/metainfo/ || die
	rm -r usr/share/appdata || die

	# Qt5 is EOL: its shim is the only thing keeping libQt5* alive after
	# upgrades (preserved libs).  The Qt6 shim is optional.
	rm -f "${YANDEX_HOME}/libqt5_shim.so" || die
	use qt6 || rm -f "${YANDEX_HOME}/libqt6_shim.so" || die

	pushd "${YANDEX_HOME}/locales" >/dev/null || die
	chromium_remove_language_paks
	popd >/dev/null || die

	default
}

src_install() {
	mv * "${ED}" || die

	# Use the system Chromium ffmpeg build for H.264/AAC.  The symlink is
	# only created when the dependency is guaranteed to be installed,
	# otherwise it would be a dangling link (QA notice).
	if use ffmpeg-codecs; then
		dosym "../../../usr/$(get_libdir)/chromium/libffmpeg.so.${CHROMIUM_VERSION}" \
			"/${YANDEX_HOME}/libffmpeg.so"
	fi

	local icon size
	for icon in "${ED}/${YANDEX_HOME}"/product_logo_*.png; do
		size=${icon##*_}
		size=${size%.png}
		newicon -s "${size}" "${icon}" "${PN}.png"
	done

	# The setuid sandbox must stay root-owned and setuid.
	fowners root:root "/${YANDEX_HOME}/yandex_browser-sandbox"
	fperms 4711 "/${YANDEX_HOME}/yandex_browser-sandbox"
	pax-mark m \
		"${ED}/${YANDEX_HOME}/yandex_browser-sandbox" \
		"${ED}/${YANDEX_HOME}/yandex_browser"
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
	xdg_icon_cache_update

	use ffmpeg-codecs ||
		ewarn "H.264/AAC playback is disabled; enable USE=ffmpeg-codecs"
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
	xdg_icon_cache_update
}
