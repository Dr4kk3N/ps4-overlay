# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

DESCRIPTION="Gamescope"
HOMEPAGE="https://github.com/Plagman/gamescope"
if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="https://github.com/Plagman/gamescope.git"
	EGIT_BRANCH="master"
	inherit git-r3
	SRC_URI="https://github.com/nothings/stb/archive/refs/heads/master.zip -> stb-master.zip"
else
	eerror "Unhandled Case"
	die
fi

src_prepare() {
	unpack stb-master.zip
	echo "project('stb', 'c')
	inc = include_directories('.')
	stb_dep = declare_dependency(include_directories : inc)
	meson.override_dependency('stb', stb_dep)" > stb-master/meson.build
	mv stb-master subprojects/stb || die
	default
}

src_install(){
	meson_src_install --skip-subprojects
	setcap cap_sys_nice+eip "${D}"/usr/bin/gamescope
}
LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""

DEPEND="
	dev-libs/stb
	gui-libs/wlroots[X]
	x11-base/xwayland
	x11-libs/libX11
	x11-libs/libXdamage
	x11-libs/libXcomposite
	x11-libs/libXrender
	x11-libs/libXext
	x11-libs/libXxf86vm
	x11-libs/libXtst
	x11-libs/libXres
	x11-libs/libdrm
	media-libs/vulkan-loader
	dev-util/vulkan-headers
	dev-libs/wayland
	dev-libs/wayland-protocols
	x11-libs/libxkbcommon
	sys-libs/libcap
	media-libs/libsdl2
	media-libs/mesa
	x11-libs/pixman
	dev-libs/libinput
	sys-auth/seatd
	x11-libs/libxcb
	x11-libs/xcb-util-wm
	dev-util/glslang
	media-video/pipewire
	x11-misc/xcb
	media-libs/vkroots
	sys-apps/hwdata
"
RDEPEND="${DEPEND}"
BDEPEND="
	dev-build/cmake
"
