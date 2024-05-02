# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake desktop fcaps flag-o-matic toolchain-funcs

DESCRIPTION="PlayStation 4 emulator"
HOMEPAGE="https://github.com/shadps4-emu/shadPS4"

if [[ ${PV} == *9999 ]]
then
	EGIT_REPO_URI="https://github.com/shadps4-emu/shadPS4.git"
	EGIT_SUBMODULES=( 'externals/boost' \
			  'externals/cryptopp' \
			  'externals/cryptopp-cmake' \
			  'externals/cryptoppwin' \
			  'externals/discord-rpc' \
			  'externals/fmt' \
			  'externals/glslang' \
			  'externals/robin-map' \
			  'externals/sdl3' \
			  'externals/wma' \
			  'externals/vulkan-headers' \
			  'externals/zlib-ng' \
			  'third-party/magic_enum' \
			  'third-party/toml11' \
			  'third-party/vulkan' \
			  'third-party/winpthread' \
			  'third-party/xxHash' \
			  'third-party/zydis/dependencies'
			)
	inherit git-r3
else
	EGIT_COMMIT=0f2540a0d1133950467845f20b1e003181147781
	ZYDIS_COMMIT=a6d0c713b71b5009634868389f0ff551871273d6
	SRC_URI="
		https://github.com/dolphin-emu/dolphin/archive/${EGIT_COMMIT}.tar.gz
			-> ${P}.tar.gz
		https://github.com/zyantific/zydis/archive/${ZYDIS_COMMIT}.tar.gz
		mgba? (
			https://github.com/mgba-emu/mgba/archive/${MGBA_COMMIT}.tar.gz
				-> mgba-${MGBA_COMMIT}.tar.gz
		)
	"
	S=${WORKDIR}/${PN}-${EGIT_COMMIT}
	KEYWORDS="~amd64 ~arm64"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="alsa discord pulseaudio sndio vulkan wayland"

COMMON_DEPEND="
	app-arch/lz4:=
	app-arch/xz-utils
	app-arch/zstd:=
	dev-libs/libaio
	app-text/doxygen
	media-libs/libglvnd
	media-libs/libpng:=
	media-libs/libsdl2[haptic,joystick]
	media-libs/libwebp:=
	media-video/ffmpeg:=
	net-libs/libpcap
	net-misc/curl
	sys-apps/dbus
	sys-libs/zlib:=
	virtual/libudev:=
	x11-libs/libXrandr
	alsa? ( media-libs/alsa-lib )
	pulseaudio? ( media-libs/libpulse )
	sndio? ( media-sound/sndio:= )
	vulkan? ( media-libs/vulkan-loader )
	wayland? ( dev-libs/wayland )
"
RDEPEND="
	${COMMON_DEPEND}
"
DEPEND="
	${COMMON_DEPEND}
	x11-base/xorg-proto
"
BDEPEND="
	dev-qt/qttools:6[linguist]
	sys-devel/clang:*
	wayland? (
		dev-util/wayland-scanner
		kde-frameworks/extra-cmake-modules
	)
"

#PATCHES=(
#	"${FILESDIR}"/${PN}-typo.patch
#)

src_configure() {
	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=OFF # to remove after unbundling
		-DUSE_LINKED_FFMPEG=yes
		-DUSE_VULKAN=$(usex vulkan)
		-DWAYLAND_API=$(usex wayland)
		-DCHECK_ALSA=$(usex alsa)
		-DCHECK_PULSE=$(usex pulseaudio)
		-DCHECK_SNDIO=$(usex sndio)
	)
	cmake_src_configure
}

src_install() {
	insinto /usr/lib/${PN}
	doins -r "${BUILD_DIR}"/bin/.

	fperms +x /usr/lib/${PN}/shadps4

	use !test || rm "${ED}"/usr/lib/${PN}/*_test || die
}
