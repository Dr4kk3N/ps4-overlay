# Copyright 2023 Kirixetamine <revelation@krxt.dev>
# Distributed under the terms of the ISC License

EAPI=7

inherit meson gnome2-utils xdg-utils

DESCRIPTION="A customizable and extensible shell"
HOMEPAGE="https://github.com/Aylur/ags"

GVC_URI="https://gitlab.gnome.org/GNOME/libgnome-volume-control"
GVC_COMMIT="8e7a5a4c3e51007ce6579292642517e3d3eb9c50"
#GVC_COMMIT="cc46b231cfaabaf99311a5257843e3f9e447f952"

GI_URI="https://gitlab.gnome.org/BrainBlasted/gi-typescript-definitions"
GI_COMMIT="94acb6307e8d467cd9b3e340a18431496636b8f6"
if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/Aylur/ags"
	EGIT_SUBMODULES=( "subprojects/gvc" "gutils" )
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
	dev-build/meson
"

#PATCHES=( "${FILESDIR}/typescript-error-suppression-9999.patch" )

src_unpack() {
	if [[ ${PV} == 9999 ]]; then
		git-r3_src_unpack
	else
		default
		rmdir ${WORKDIR}/${P}/subprojects/gvc || die
		rmdir ${WORKDIR}/${P}/gi-types || die
		ln -sv "${WORKDIR}/libgnome-volume-control-${GVC_COMMIT}" ${WORKDIR}/${P}/subprojects/gvc || die
		ln -sv "${WORKDIR}/gi-typescript-definitions-${GI_COMMIT}" ${WORKDIR}/${P}/gi-types || die
	fi
}

src_configure() {
	default
	npm install
	meson setup build --prefix /usr
}

src_compile() {
	default
	meson_src_compile -C build
}

src_install() {
	meson_src_install -C build --destdir "${D}"
}

pkg_postinst() {
	elog "To learn on how to use ags, please read"
	elog "https://github.com/Aylur/ags/wiki/configuration"
	elog "which describes its usage and configuration."
}
