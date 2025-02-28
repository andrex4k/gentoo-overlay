# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="The World's First Agentic IDE by Codeium"
HOMEPAGE="https://codeium.com/windsurf"
SRC_URI="https://windsurf-stable.codeiumdata.com/linux-x64/stable/43976ecab7354ba352849517e15779fe8a4eff88/Windsurf-linux-x64-${PV}.tar.gz"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="~amd64"
IUSE="alsa cairo cups ffmpeg gtk wayland X"

RDEPEND="
    alsa? ( media-libs/alsa-lib )
    dev-libs/atk
    app-accessibility/at-spi2-core
    cairo? ( x11-libs/cairo )
    sys-libs/libcap
    cups? ( net-print/cups )
    sys-apps/dbus
    x11-libs/libdrm
    media-libs/libepoxy
    dev-libs/expat
    dev-libs/libffi
    ffmpeg? ( media-video/ffmpeg )
    media-libs/fontconfig
    media-libs/freetype
    dev-libs/fribidi
    media-libs/mesa
    gtk? ( x11-libs/gtk+:3 )
    media-libs/graphite2
    dev-libs/gnutls
    dev-libs/glib
    media-libs/harfbuzz
    dev-libs/nettle
    net-dns/libidn2
    virtual/jpeg
    sys-apps/util-linux
    dev-libs/nettle
    dev-libs/nspr
    dev-libs/nss
    dev-libs/p11-kit
    x11-libs/pango
    dev-libs/libpcre2
    x11-libs/pixman
    media-libs/libpng
    sys-apps/systemd
    dev-libs/libtasn1
    dev-libs/libunistring
    wayland? ( dev-libs/wayland )
    X? (
    x11-libs/libX11
    x11-libs/libXau
    x11-libs/libxcb
    x11-libs/libXcomposite
    x11-libs/libXcursor
    x11-libs/libXdamage
    x11-libs/libXdmcp
    x11-libs/libXext
    x11-libs/libXfixes
    x11-libs/libXi
    x11-libs/libxkbcommon
    x11-libs/libXrandr
    x11-libs/libXrender
    )
    sys-libs/zlib
"

QA_PREBUILT="opt/${PN}/*"
RESTRICT="strip"

S="${WORKDIR}"

src_install() {
    # Create installation directory
    insinto /opt/${PN}
    doins -r *

    # Make the main executable executable
    fperms 755 /opt/${PN}/windsurf

    # Create symlink in /usr/bin
    dosym ../opt/${PN}/windsurf /usr/bin/windsurf

    # Add desktop entry
    domenu "${FILESDIR}/${PN}.desktop"
}
