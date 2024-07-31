# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=8

inherit git-r3 cmake xdg xdg-utils

DESCRIPTION="Examples and demos for the Vulkan API"
HOMEPAGE="https://github.com/SaschaWillems/Vulkan"

EGIT_REPO_URI="https://github.com/SaschaWillems/Vulkan.git"
SRC_URI="http://vulkan.gpuinfo.org/downloads/vulkan_asset_pack.zip"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="+X wayland d2d headless"

REQUIRED_USE="^^ ( X wayland d2d headless )"

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
		dev-util/wayland-scanner
		gui-libs/egl-wayland
	)
	d2d? (
		x11-libs/libxcb:=
	)
"

DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
        eapply -p1 "${FILESDIR}"/data.patch
        eapply_user
	cmake_src_prepare
}

src_configure() {
    local mycmakeargs=(
		-DCMAKE_BUILD_TYPE=Release
		-DUSE_WAYLAND_WSI=$(usex wayland)
		-DUSE_D2D_WSI=$(usex d2d)
		-USE_HEADLESS=$(usex headless)
		-Wno-dev
    )
	cmake_src_configure
}

src_install() {
	mkdir -p "${D}"/usr/share/vulkan/{demos,data}

	exeinto /usr/share/vulkan/demos

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

	domenu "${FILESDIR}"/vulkanscene.desktop

	doicon -s 128 "${FILESDIR}"/vulkanscene.png
#       doicon -s scalable assets/vulkanscene.svg

        exeinto "/user/share/vulkan/demos"
        dosym "/usr/share/vulkan/demos/vulkanscene" "/usr/bin/vulkanscene"
}

pkg_postinst() {
        xdg_icon_cache_update
}

pkg_postrm() {
        xdg_icon_cache_update
}
