# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

DESCRIPTION="The theme from libadwaita ported to GTK-3"
HOMEPAGE="https://github.com/lassekongo83/adw-gtk3"

if [[ "${PV}" = 9999 ]]; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/lassekongo83/adw-gtk3.git"
else
	SRC_URI="https://github.com/lassekongo83/adw-gtk3/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi

LICENSE="LGPL-2.1"
SLOT="0"
IUSE="dark"
RESTRICT="binchecks strip test"

BDEPEND="dev-lang/sassc"

RDEPEND="
	|| (
		gui-libs/gtk:4
		>=x11-libs/gtk+-3.24:3
	)
"

DOCS=(
	CONTRIBUTING.md
	README.md
)

src_configure() {
	local emesonargs=( $(meson_use dark) )

	meson_src_configure
}
