# Copyright 2023-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="The hyprland cursor format, library and utilities."
HOMEPAGE="https://github.com/hyprwm/hyprcursor"
SRC_URI="https://github.com/hyprwm/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
#https://github.com/hyprwm/hyprcursor/releases/download/v0.1.4/v0.1.4.tar.gz
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

BDEPEND="
	dev-libs/hyprlang:=
	dev-libs/wayland
	dev-libs/wayland-protocols
	dev-util/wayland-scanner
	dev-vcs/git
"
RDEPEND="
	media-libs/libwebp
	x11-libs/cairo
	x11-libs/pango
"

src_compile() {
#	emake protocols
	cmake_src_compile
}

#src_install() {
#	dobin "${BUILD_DIR}/${PN}"
#}
