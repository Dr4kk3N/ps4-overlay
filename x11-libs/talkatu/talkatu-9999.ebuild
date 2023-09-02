# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit mercurial meson vala virtualx

DESCRIPTION="GTK widgets for chat applications"
HOMEPAGE="https://keep.imfreedom.org/talkatu/talkatu"
SRC_URI=""
EHG_REPO_URI="https://keep.imfreedom.org/talkatu/talkatu"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="doc man +introspection nls test vala"

REQUIRED_USE="vala? ( introspection )"

RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-libs/glib-2.40.0:2
	>=x11-libs/gtk+-3.18.0:3[introspection?]
	introspection? ( >=dev-libs/gobject-introspection-1.30.0 )
	>=app-text/gspell-1.2:0=
	>=dev-libs/gumbo-0.10
	app-text/cmark:=
"

DEPEND="${RDEPEND}"

BDEPEND="
	virtual/pkgconfig
	dev-util/glade
	doc? ( dev-util/gtk-doc )
	man? ( sys-apps/help2man[nls?] )
	nls? ( sys-devel/gettext )
	test? ( x11-misc/xvfb-run )
	vala? ( $(vala_depend) )
"

DOCS=( AUTHORS HACKING INSTALL README.md ChangeLog logo.png )

src_unpack() {
	mercurial_src_unpack
}

src_prepare() {
	default

	use vala && vala_src_prepare

	# We do not want to create packages for other distros
	sed -i -e '/subdir.*packaging/d' meson.build || die

	# Prevent installing documentation, we have our own way
	sed -i -e '/^install_data/,/^$/d' meson.build || die
}

src_configure() {
	local emesonargs=(
		$(meson_use doc)
		$(meson_use nls)
		$(meson_use man help2man)
		$(meson_use test tests)
		$(meson_use vala vapi)
	)
	meson_src_configure
}

src_compile() {
	meson_src_compile
}

src_install() {
	meson_src_install
}

src_test() {
	virtx meson_src_test
}
