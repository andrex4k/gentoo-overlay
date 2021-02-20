EAPI=7

inherit cmake flag-o-matic unpacker

TG_OWT_COMMIT="be23804afce3bb2e80a1d57a7c1318c71b82b7de"
LIBYUV_COMMIT="ad890067f661dc747a975bc55ba3767fe30d4452"
LIBYUV_P="libyuv-0_pre20201119"
LIBVPX_COMMIT="5b63f0f821e94f8072eb483014cfc33b05978bb9"
LIBVPX_P="libvpx-1.9.0_p20201118"

DESCRIPTION="WebRTC build for Telegram"
HOMEPAGE="https://github.com/desktop-app/tg_owt"
SRC_URI="https://github.com/desktop-app/tg_owt/archive/${TG_OWT_COMMIT}.tar.gz -> ${P}.tar.gz
	https://chromium.googlesource.com/libyuv/libyuv/+archive/${LIBYUV_COMMIT}.tar.gz -> ${LIBYUV_P}.tar.gz
	https://chromium.googlesource.com/webm/libvpx.git/+archive/${LIBVPX_COMMIT}.tar.gz -> ${LIBVPX_P}.tar.gz
"
LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64"
IUSE="pulseaudio"

# some things from this list are bundled
# work on unbundling in progress
DEPEND="
	dev-libs/openssl:=
	dev-libs/protobuf:=
	media-libs/alsa-lib
	media-libs/libjpeg-turbo:=
	media-libs/openh264:=
	media-libs/opus
	media-video/ffmpeg:=
	!pulseaudio? ( media-sound/apulse[sdk] )
	pulseaudio? ( media-sound/pulseaudio )
"

RDEPEND="${DEPEND}"

BDEPEND="
	virtual/pkgconfig
	amd64? ( dev-lang/yasm )
"

S="${WORKDIR}/${PN}-${TG_OWT_COMMIT}"

src_unpack() {
	pwd
	unpack ${P}.tar.gz
	pwd
	pushd ${PN}-${TG_OWT_COMMIT} > /dev/null
	pushd src/third_party/libyuv > /dev/null
	pwd
	unpack ${LIBYUV_P}.tar.gz
	popd > /dev/null
	pwd
	pushd src/third_party/libvpx/source/libvpx > /dev/null
	pwd
	unpack ${LIBVPX_P}.tar.gz
	popd > /dev/null
	pwd
	popd > /dev/null
}

src_configure() {
	# lacks nop, can't restore toc
#	append-flags '-fPIC'
	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=OFF
		-DTG_OWT_PACKAGED_BUILD=OFF
		-DTG_OWT_USE_PROTOBUF=OFF
	)
	cmake_src_configure
}
