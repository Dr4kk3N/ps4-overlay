# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LIBRETRO_REPO_NAME="libretro/dolphin"
LIBRETRO_CORE_NAME="dolphin"

inherit libretro-core cmake

DESCRIPTION="A Gamecube/Wii emulator core for libretro"
HOMEPAGE="https://github.com/libretro/dolphin"
KEYWORDS=""
IUSE="+opengl vulkan +X"

LICENSE="GPL-2"
SLOT="0"

RDEPEND="
	dev-libs/hidapi:0=
	dev-libs/libfmt:0=
	dev-libs/lzo:2=
	dev-libs/pugixml:0=
	dev-qt/qtconcurrent
	media-libs/libpng:0=
	media-libs/libsfml
	media-libs/mesa
	net-libs/enet:1.3
	net-libs/mbedtls:0=
	net-misc/curl:0=
	sys-libs/readline:0=
	sys-libs/zlib:0=
	X? (
		x11-libs/libXext
		x11-libs/libXi
		x11-libs/libXrandr
	)
	virtual/libusb:1
	opengl? ( virtual/opengl )
	vulkan? ( media-libs/vulkan-loader )
"
RDEPEND="${DEPEND}
	games-emulation/libretro-info"

src_prepare() {
	libretro-core_src_prepare
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DCCACHE_BIN=CCACHE_BIN-NOTFOUND
		-DENABLE_LLVM=OFF
		-DBUILD_SHARED_LIBS=OFF
		-DLIBRETRO=ON
		-DLIBRETRO_STATIC=1
		-DENABLE_QT=0
		-DUSE_SHARED_ENET=ON
		-DCMAKE_BUILD_TYPE=Release
		-DCMAKE_INSTALL_PREFIX=/usr
		-DENABLE_X11=$(usex X)
	)
	cmake_src_configure
}

src_install() {
	LIBRETRO_CORE_LIB_FILE="${BUILD_DIR}/${LIBRETRO_CORE_NAME}_libretro.so"
	libretro-core_src_install
}
