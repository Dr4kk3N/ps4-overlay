# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson git-r3

DESCRIPTION="A client-side decorations library for Wayland clients"
HOMEPAGE="https://gitlab.freedesktop.org/libdecor/libdecor"
EGIT_REPO_URI="https://gitlab.freedesktop.org/libdecor/libdecor.git"

LICENSE="MIT"
SLOT="0"
IUSE="+dbus examples"

DEPEND="
	>=dev-libs/wayland-1.18
	>=dev-libs/wayland-protocols-1.15
	x11-libs/pango
	dbus? ( sys-apps/dbus )
	examples? (
		virtual/opengl
		media-libs/mesa[egl(+)]
		x11-libs/libxkbcommon
	)
"
RDEPEND="${DEPEND}"
BDEPEND=""

src_configure() {
	local emesonargs=(
		# Avoid auto-magic, built-in feature of meson
		-Dauto_features=disabled

		$(meson_feature dbus)
		$(meson_use examples demo)
		-Dinstall_demo=true
	)

	meson_src_configure
}
