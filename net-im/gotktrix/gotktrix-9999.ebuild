# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module optfeature

DESCRIPTION="Matrix client in Go and GTK4"
HOMEPAGE="https://github.com/diamondburned/gotktrix"

if [[ ${PV} == 9999 ]]
then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/diamondburned/${PN}"

	src_unpack() {
		git-r3_src_unpack
		go-module_live_vendor
	}
else
	EGO_SUM=(
	)

	go-module_set_globals

	SRC_URI="
		https://github.com/diamondburned/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
		${EGO_SUM_SRC_URI}
	"
	KEYWORDS="~amd64"
fi

LICENSE="AGPL-3"
SLOT="0"
IUSE="+secrets"

RDEPEND="
	dev-libs/glib
	dev-libs/gobject-introspection
	gui-libs/gtk:4[introspection]
	media-libs/graphene[introspection]
	secrets? ( virtual/secret-service )
	x11-libs/gdk-pixbuf[introspection]
"
DEPEND="${RDEPEND}"

src_compile() {
	use elibc_musl && export CGO_LDFLAGS="${CGO_LDFLAGS} -Wl,-z,stack-size=2097152"
	go build || die
}

src_install() {
	einstalldocs
	dobin gotktrix
}

pkg_postinst() {
	optfeature "Notification Sounds via libcanberra" media-libs/libcanberra[gtk3]
}
