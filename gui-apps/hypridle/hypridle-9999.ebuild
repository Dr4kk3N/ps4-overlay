# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Hyprland's idle daemon"
HOMEPAGE="https://github.com/hyprwm/hypridle"

if [[ "${PV}" = 9999 ]]; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/hyprwm/hypridle.git"
else
	SRC_URI="https://github.com/hyprwm/hypridle/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi

LICENSE="BSD"
SLOT="0"
RESTRICT="test"

MY_COMMON_DEPEND="
	dev-cpp/sdbus-c++:=
	>=dev-libs/hyprlang-0.4.0
	dev-libs/wayland
"

DEPEND="
	dev-libs/wayland-protocols
	${MY_COMMON_DEPEND}
"

BDEPEND="
	dev-util/wayland-scanner
	virtual/pkgconfig
"

RDEPEND="
	dev-libs/libffi
	sys-libs/libcap
	${MY_COMMON_DEPEND}
"

PATCHES=( "${FILESDIR}/${P}-fix-cxxflags.patch" )
