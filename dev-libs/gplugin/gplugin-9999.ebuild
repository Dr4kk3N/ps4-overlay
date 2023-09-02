# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{10..12} )

inherit meson python-single-r1 vala

DESCRIPTION="GObject based plugin system library supporting different languages"
HOMEPAGE="https://keep.imfreedom.org/gplugin/gplugin"

if [[ ${PV} = *9999* ]] ; then
	inherit mercurial
	EHG_REPO_URI="https://keep.imfreedom.org/gplugin/gplugin"
	EHG_REVISION="default"
else
	SRC_URI="https://bitbucket.org/gplugin/gplugin/downloads/${P}.tar.xz"
	KEYWORDS="~alpha ~amd64 ~arm64 ~hppa ~ppc ~ppc64 ~sparc ~x86"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="doc man +introspection nls +gtk lua perl python tcc vala"

REQUIRED_USE="
	lua? ( introspection )
	perl? ( introspection )
	python? ( introspection ${PYTHON_REQUIRED_USE} )
	vala? ( introspection )
"

# perl: needs ExtUtils::Embed, not in official Portage tree
# tcc: will not build successfully

RDEPEND="
	>=dev-libs/glib-2.40.0:2
	introspection? ( >=dev-libs/gobject-introspection-1.30.0 )
	gtk? ( >=gui-libs/gtk-4.10.4:4[introspection?] )
	lua? (
		dev-lua/lgi
		|| ( dev-lang/luajit:2 dev-lang/lua:= ) )
	perl? (
		dev-perl/Glib-Object-Introspection
		dev-lang/perl:0= )
	python? (
		${PYTHON_DEPS}
		$(python_gen_cond_dep 'dev-python/pygobject:3[${PYTHON_USEDEP}]') )
	tcc? ( dev-lang/tcc )
"

DEPEND="${RDEPEND}"

BDEPEND="
	virtual/pkgconfig
	gtk? ( dev-util/glade )
	doc? ( dev-util/gtk-doc )
	man? ( sys-apps/help2man[nls?] )
	nls? ( sys-devel/gettext )
	vala? ( $(vala_depend) )
"

DOCS=( HACKING.md INSTALL.md README.md ChangeLog COPYRIGHT HISTORY.md )

pkg_setup() {
	use python && python-single-r1_pkg_setup
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
		$(meson_use lua)
		$(meson_use python python3)
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
