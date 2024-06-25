# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson git-r3

DESCRIPTION="A wayland based logout menu"
HOMEPAGE="https://github.com/ArtsyMacaw/wlogout"
EGIT_REPO_URI="https://github.com/ArtsyMacaw/wlogout.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="layershell doc bash-completions fish-completions zsh-completions"

DEPEND="x11-libs/gtk+[wayland(-)]
		dev-libs/gobject-introspection
		doc? ( app-text/scdoc )
		layershell? ( gui-libs/gtk-layer-shell )"
RDEPEND="${DEPEND}"

src_configure() {
	local emesonargs=(
		$(meson_feature doc man-pages)
		$(meson_use bash-completions)
		$(meson_use fish-completions)
		$(meson_use zsh-completions)
	)
	meson_src_configure
}

src_compile() {
	meson_src_compile
}

src_install() {
	meson_src_install
}
