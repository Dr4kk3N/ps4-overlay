# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Official utils for Hyprland."
HOMEPAGE="https://github.com/hyprwm/hyprutils"

if [[ ${PV} = 9999* ]]; then
        EGIT_REPO_URI="https://github.com/hyprwm/hyprutils.git/"
        inherit git-r3
else
	COMMIT=bb1437add2df7f76147f7beb430365637fc2c35e
	SPLITCOMMIT=feb6ab9a4929a92d41c724f6d16e9d351b12de39
	SRC_URI="https://github.com/hyprwm/${PN}/archive/${COMMIT}.tar.gz -> ${P}.gh.tar.gz
		https://github.com/hyprwm/Hyprland/releases/download/v${PV}/source-v${PV}.tar.gz \
		-> ${P}-hyprsrc.gh.tar.gz"
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-${COMMIT}"
fi

LICENSE="BSD"
SLOT="0"
IUSE="X"

RDEPEND="gui-wm/hyprland"
DEPEND="${RDEPEND}"
BDEPEND="
	~gui-wm/hyprland-${PV}
	x11-libs/libdrm
	x11-libs/pixman
	x11-libs/xcb-util-wm
"

