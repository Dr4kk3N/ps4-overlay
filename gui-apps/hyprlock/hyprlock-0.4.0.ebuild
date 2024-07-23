# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Hyprland's GPU-accelerated screen locking utility"
HOMEPAGE="https://github.com/hyprwm/hyprlock"

if [[ "${PV}" = 9999 ]]; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/hyprwm/hyprlock.git"
else
	SRC_URI="https://github.com/hyprwm/hyprlock/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi

LICENSE="BSD"
SLOT="0"
RESTRICT="test"

DEPEND="
	dev-libs/expat
	dev-libs/fribidi
	dev-libs/glib:2
	>=dev-libs/hyprlang-0.4.0
	dev-libs/libffi:=
	dev-libs/libpcre2:=
	dev-libs/wayland
	dev-libs/wayland-protocols
	>=gui-libs/hyprutils-0.1.1
	media-gfx/graphite2
	media-libs/fontconfig:1.0
	media-libs/freetype:2
	media-libs/harfbuzz:=
	media-libs/libglvnd
	media-libs/libjpeg-turbo:=
	media-libs/libpng:=
	media-libs/libwebp:=
	media-libs/mesa
	sys-libs/pam
	sys-libs/zlib:=
	x11-libs/cairo
	x11-libs/libdrm
	x11-libs/libX11
	x11-libs/libXau
	x11-libs/libxcb:=
	x11-libs/libXdmcp
	x11-libs/libXext
	x11-libs/libxkbcommon
	x11-libs/libXrender
	x11-libs/pango
	x11-libs/pixman
"

BDEPEND="
	dev-util/wayland-scanner
	virtual/pkgconfig
"

RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/${P}-fix-cxxflags.patch" )
