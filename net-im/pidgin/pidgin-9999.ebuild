# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit mercurial meson xdg

DESCRIPTION="GTK Instant Messenger client"
HOMEPAGE="https://pidgin.im/"
SRC_URI=""
EHG_REPO_URI="https://keep.imfreedom.org/pidgin/pidgin"

LICENSE="GPL-2"
SLOT="0/3"
KEYWORDS=""
IUSE="X debug doc eds +introspection gadu +gstreamer +gtk meanwhile ncurses
nettle plugins kwallet nls sasl prediction zeroconf secret"

REQUIRED_USE="
	eds? ( gtk plugins )
	kwallet? ( plugins )
	prediction? ( gtk plugins )
"

RDEPEND="
	>=dev-libs/glib-2.48.0:2
	>=dev-libs/json-glib-1.4.4
	>=dev-libs/libxml2-2.6.18:2
	>=net-libs/libsoup-2.42:2.4
	dev-libs/hasl
	net-dns/libidn:0=
	nettle? ( >=dev-libs/nettle-3.0:0= )
	gtk? (
		>=x11-libs/gtk+-3.22.0:3[introspection?]
		>=x11-libs/talkatu-0.1.0[introspection?]
		eds? ( >=gnome-extra/evolution-data-server-3.6:= )
		prediction? ( >=dev-db/sqlite-3.3:3 ) )
	gstreamer? (
		media-libs/gstreamer:1.0
		media-libs/gst-plugins-base:1.0
		>=net-libs/farstream-0.2.7:0.2= )
	plugins? ( >=media-libs/libcanberra-0.30 )
	X? (
		x11-base/xorg-proto
		x11-libs/libX11 )
	introspection? ( >=dev-libs/gobject-introspection-1.30.0 )
	zeroconf? ( net-dns/avahi )
	secret? ( app-crypt/libsecret )
	gadu? ( >=net-libs/libgadu-1.12.0 )
	meanwhile? (
		=net-libs/meanwhile-1*
		dev-libs/gmime:3.0 )
	ncurses? ( >=dev-libs/libgnt-3.0.0[introspection?] )
	sasl? ( dev-libs/cyrus-sasl:2 )
	>=dev-libs/gplugin-0.29.1[gtk?,introspection?]
	kwallet? ( kde-frameworks/kwallet )
"

DEPEND="${RDEPEND}"

BDEPEND="
	virtual/pkgconfig
	doc? ( dev-util/gtk-doc )
	nls? ( sys-devel/gettext )
"

DOCS=( AUTHORS COPYRIGHT NEWS README ChangeLog ChangeLog.API )

src_unpack() {
	mercurial_src_unpack
}

pkg_pretend() {
	if ! use gtk && ! use ncurses; then
		elog "You did not pick the ncurses or gtk use flags, only libpurple"
		elog "will be built."
	fi
}

src_configure() {
	local emesonargs=(
		$(meson_use doc)
		$(meson_use gtk gtkui)
		$(meson_use ncurses consoleui)
		$(meson_use X x)
		-Dintrospection=true
		-Dkwallet=disabled
		-Davahi=disabled
		-Dlibgadu=enabled
		-Dconsole-logging=false
		-Dunity-integration=disabled
		--buildtype $(usex debug debug plain)
	)
	meson_src_configure
}

src_compile() {
	meson_src_compile
}

src_install() {
	meson_src_install
}

pkg_preinst() {
	xdg_pkg_preinst
}

pkg_postinst() {
	xdg_pkg_postinst
}

pkg_postrm() {
	xdg_pkg_postrm
}
