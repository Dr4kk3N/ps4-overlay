# Copyright 2024 Kirixetamine <revelation@krxt.dev>
# Distributed under the terms of the ISC License

EAPI=7
RESTRICT="mirror"

inherit meson gnome2-utils xdg-utils

DESCRIPTION="A customizable and extensible shell"
HOMEPAGE="https://github.com/Aylur/ags"

GVC_URI="https://gitlab.gnome.org/GNOME/libgnome-volume-control"
GVC_COMMIT="91f3f41490666a526ed78af744507d7ee1134323"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/Aylur/ags"
	EGIT_SUBMODULES=( "subprojects/gvc" )
else
	SRC_URI="
		$HOMEPAGE/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
		$GVC_URI/-/archive/${GVC_COMMIT}.tar.gz
		$GI_URI/-/archive/${GI_COMMIT}.tar.gz
	"
	S="${WORKDIR}/${P}"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-3"
SLOT="0"
IUSE=""

DEPEND="
	dev-libs/gjs
	x11-libs/gtk+
	gui-libs/gtk-layer-shell[introspection]
	net-wireless/gnome-bluetooth

	sys-power/upower
	net-misc/networkmanager
	dev-libs/gobject-introspection
	dev-libs/libdbusmenu[gtk3]
"
BDEPEND="
	net-libs/nodejs
	dev-lang/typescript
"

src_unpack() {
	if [[ ${PV} == 9999 ]]; then
		git-r3_src_unpack
		default
	else
		default
	fi
}

src_configure() {
	default
	npm install
	meson setup build --prefix /usr || die
}

src_compile() {
	default
	meson_src_compile -C build || die
}

src_install() {
	meson_src_install -C build --destdir "${D}" || die
}

pkg_postinst() {
	elog "To learn on how to use ags, please read"
	elog "https://github.com/Aylur/ags/wiki/configuration"
	elog "which describes its usage and configuration."
}
