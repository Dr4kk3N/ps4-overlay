# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=7

inherit git-r3 cmake font

DESCRIPTION="Examples and demos for the Vulkan API"
HOMEPAGE="https://github.com/SaschaWillems/Vulkan"

EGIT_REPO_URI="https://github.com/SaschaWillems/Vulkan.git"
SRC_URI="http://vulkan.gpuinfo.org/downloads/vulkan_asset_pack.zip"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="+X wayland"

RDEPEND="media-libs/vulkan-loader
	dev-build/cmake
	media-libs/assimp
	X? (
		x11-libs/libX11
		x11-libs/libXcomposite
		x11-libs/libXext
		x11-libs/libXfixes
		x11-libs/libXrandr
		x11-libs/libxcb:=
	)
	wayland? (
		dev-libs/wayland-protocols
		dev-libs/wayland
		gui-libs/egl-wayland
	)"

DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	cmake_src_prepare
}

src_configure() {
    local mycmakeargs=(
		-DRESOURCE_INSTALL_DIR=/usr/share/vulkan/data/
		#-DCMAKE_INSTALL_BINDIR=/usr/bin/
		-DUSE_WAYLAND_WSI=$(usex wayland)
		-DUSE_DIRECTFB_WSI=OFF
		-DUSE_D2D_WSI=OFF
		-Wno-dev
    )
	cmake_src_configure
}

src_install() {
	mkdir -p "${D}"/usr/share/vulkan/{demos,data}

	exeinto /usr/share/vulkan/demos
	doexe ${BUILD_DIR}/bin/vulkanscene
	rm ${BUILD_DIR}/bin/vulkanscene

	cd ${BUILD_DIR}/bin/
	for filename in * ; do mv "$filename" "vulkan$filename"; done;
	doexe ${BUILD_DIR}/bin/*

	insinto /usr/share/vulkan/data
	doins -r ${S}/shaders
	doins -r ${S}/assets
	doins -r ${S}/images

	mkdir -p "${D}/usr/share/fonts/truetype/vulkandemos/"
	dosym /usr/share/vulkan/data/assets/Roboto-Medium.ttf /usr/share/fonts/truetype/vulkandemos/Roboto-Medium.ttf
	font_src_install
}
