# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="A wlroots-compatible Wayland color picker that does not suck"
HOMEPAGE="https://github.com/hyprwm/hyprpicker"

if [[ "${PV}" = 9999 ]]; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/hyprwm/hyprpicker.git"
else
	SRC_URI="https://github.com/hyprwm/hyprpicker/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi

LICENSE="BSD"
SLOT="0"
RESTRICT="test"

DEPEND="
	dev-libs/expat
	dev-libs/libffi:=
	dev-libs/wayland
	dev-libs/wayland-protocols
	media-libs/fontconfig:1.0
	media-libs/freetype:2
	media-libs/libpng:=
	sys-libs/zlib:=
	x11-libs/cairo
	x11-libs/libX11
	x11-libs/libXau
	x11-libs/libxcb:=
	x11-libs/libXdmcp
	x11-libs/libXext
	x11-libs/libxkbcommon
	x11-libs/libXrender
	x11-libs/pixman
"

BDEPEND="
	dev-util/wayland-scanner
	virtual/pkgconfig
"

RDEPEND="${DEPEND}"
