# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit optfeature

DESCRIPTION="Official plugins for Hyprland."
HOMEPAGE="https://github.com/hyprwm/hyprland-plugins"

if [[ ${PV} = 9999* ]]; then
        EGIT_REPO_URI="https://github.com/hyprwm/hyprland-plugins.git/"
        inherit git-r3
else
	COMMIT=bb1437add2df7f76147f7beb430365637fc2c35e
	SRC_URI="https://github.com/hyprwm/${PN}/archive/${COMMIT}.tar.gz -> ${P}.gh.tar.gz
		https://github.com/hyprwm/Hyprland/releases/download/v${PV}/source-v${PV}.tar.gz \
		-> ${P}-hyprsrc.gh.tar.gz"
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-${COMMIT}"
fi

LICENSE="BSD"
SLOT="0"
IUSE="+borders-plus-plus csgo-vulkan-fix +hyprbars hyprexpo hyprtrails hyprwinwrap X"
REQUIRED_USE="|| ( borders-plus-plus csgo-vulkan-fix hyprbars )"

RDEPEND="gui-wm/hyprland"
DEPEND="${RDEPEND}"
BDEPEND="~gui-wm/hyprland-${PV}
	x11-libs/libdrm
	x11-libs/pixman
	x11-libs/xcb-util-wm
"

src_compile() {
	emake -C "${WORKDIR}/hyprland-source" protocols
	export HYPRLAND_HEADERS="${WORKDIR}/hyprland-source"

	if use borders-plus-plus; then
		emake -C "${S}/borders-plus-plus" all
	fi

	if use csgo-vulkan-fix; then
		emake -C "${S}/csgo-vulkan-fix" all
	fi

	if use hyprbars; then
		emake -C "${S}/hyprbars" all
	fi

	if use hyprexpo; then
                emake -C "${S}/hyprexpo" all
        fi

	if use hyprtrails; then
                emake -C "${S}/hyprtrails" all
        fi

	if use hyprwinwrap; then
                emake -C "${S}/hyprwinwrap" all
        fi
}

src_install() {
	insinto "/usr/share/hyprland/plugins"

	if use borders-plus-plus; then
		doins "${S}/borders-plus-plus/borders-plus-plus.so"
	fi

	if use csgo-vulkan-fix; then
		doins "${S}/csgo-vulkan-fix/csgo-vulkan-fix.so"
	fi

	if use hyprbars; then
		doins "${S}/hyprbars/hyprbars.so"
	fi

	if use hyprexpo; then
                doins "${S}/hyprexpo/hyprexpo.so"
        fi

	if use hyprtrails; then
                doins "${S}/hyprtrails/hyprtrails.so"
        fi

	if use hyprwinwrap; then
                doins "${S}/hyprwinwrap/hyprwinwrap.so"
        fi
}

pkg_postinst() {
	einfo "Plugins are installed in /usr/share/hyprland/plugins"
	einfo "To load them, refer to the official documentation"
	einfo "https://wiki.hyprland.org/Plugins/Using-Plugins/"
}
