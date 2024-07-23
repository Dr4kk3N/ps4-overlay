# Copyright 2023-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake toolchain-funcs flag-o-matic

replace-flags -O2 -O3

DESCRIPTION="A very light linux rendering backend library."
HOMEPAGE="https://github.com/hyprwm/aquamarine"

if [[ "${PV}" = *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/hyprwm/aquamarine/${PN}.git"
else
	SRC_URI="https://github.com/hyprwm/${PN}/releases/download/v${PV}/source-v${PV}.tar.gz -> ${P}.gh.tar.gz"
	S="${WORKDIR}/${PN}-source"

	KEYWORDS="~amd64"
fi

LICENSE="BSD"
SLOT="0"
IUSE="X debug"

RDEPEND="
	dev-libs/glib:2
	dev-libs/libinput
	>=dev-libs/wayland-1.20.0
	>=gui-libs/hyprcursor-0.1.7
	media-libs/libglvnd
	x11-libs/cairo
	x11-libs/libdrm
	x11-libs/libxkbcommon
	x11-libs/pango
	x11-libs/pixman
	X? (
		x11-libs/libxcb:0=
	)
"
DEPEND="
	${RDEPEND}
	>=dev-libs/hyprland-protocols-0.2
	>=dev-libs/hyprlang-0.3.2
	>=dev-libs/wayland-protocols-1.34
	sys-auth/seatd
	>=dev-libs/libinput-1.26.0
	x11-libs/libdrm
	x11-libs/pixman
"
BDEPEND="
	dev-build/cmake
	dev-util/hyprwayland-scanner
	virtual/pkgconfig
"

src_configure() {
#	local mycmakeargs=(
#		-DLEGACY_RENDERER=$(usex legacy-renderer '1' '0')
#		-DNO_SYSTEMD=$(usex systemd '0' '1')
#		-DNO_XWAYLAND=$(usex X '0' '1')
#		-Dwlroots:backends=drm,libinput$(usev X ',x11')
#		-Dwlroots:xcb-errors=disabled
#	)

	cmake_src_configure
}

src_install() {
	cmake_src_install
}
