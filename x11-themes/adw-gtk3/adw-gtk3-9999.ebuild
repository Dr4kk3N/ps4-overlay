# Copyright 2023 Kirixetamine <revelation@krxt.dev>
# Distributed under the terms of the ISC License

EAPI=8

inherit meson

DESCRIPTION="The theme from libadwaita ported to GTK-3"
HOMEPAGE="https://github.com/lassekongo83/adw-gtk3"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/lassekongo83/adw-gtk3"
else
	SRC_URI="https://github.com/lassekongo83/adw-gtk3/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="LGPL-2.1"
SLOT="0"

BDEPEND="
	dev-lang/sassc
	dev-build/ninja
"

src_compile() {
	meson build
	meson compile -C build
}

src_install() {
	local themes=(
		adw-gtk3
		adw-gtk3-dark
	)

	meson install -C build --destdir ${S}/complete

	insinto /usr/share/themes
	for theme in ${themes[@]}; do
		doins -r "complete/usr/share/themes/${theme}"
	done
	einstalldocs
}
