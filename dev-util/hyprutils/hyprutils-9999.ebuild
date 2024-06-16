# Copyright 2023-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake toolchain-funcs

DESCRIPTION="A dynamic tiling Wayland compositor that doesn't sacrifice on its looks"
HOMEPAGE="https://github.com/hyprwm/Hyprland"

inherit git-r3
EGIT_REPO_URI="https://github.com/hyprwm/${PN^}.git"

LICENSE="BSD"
SLOT="0"
IUSE="X legacy-renderer systemd"
KEYWORDS="~amd64"

# hyprpm (hyprland plugin manager) requires the dependencies at runtime
# so that it can clone, compile and install plugins.
HYPRPM_RDEPEND="
	app-alternatives/ninja
	dev-build/cmake
"

BDEPEND="
	${HYPRPM_RDEPEND}
"

src_configure() {
	cmake_src_configure
}

src_install() {
	cmake_src_install
}
