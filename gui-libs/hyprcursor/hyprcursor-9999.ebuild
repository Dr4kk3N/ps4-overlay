# Copyright 2023-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake git-r3

DESCRIPTION="The hyprland cursor format, library and utilities"
HOMEPAGE="https://github.com/hyprwm/hyprcursor"
EGIT_REPO_URI="${HOMEPAGE}.git"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~riscv"

# Disable tests since as per the documentation, tests require a theme to be installed
# See also https://github.com/hyprwm/hyprcursor/commit/94361fd8a75178b92c4bb24dcd8c7fac8423acf3
RESTRICT="test"
RDEPEND="
	dev-libs/hyprlang
	dev-libs/libzip
	gnome-base/librsvg
	x11-libs/cairo
"
