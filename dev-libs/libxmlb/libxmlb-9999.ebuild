# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )

inherit meson python-any-r1

if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/hughsie/${PN}"
else
SRC_URI="https://github.com/hughsie/libxmlb/archive/${PV}.tar.gz -> ${P}.tar.gz"
fi

DESCRIPTION="Library to help create and query binary XML blobs"
HOMEPAGE="https://github.com/hughsie/libxmlb"
LICENSE="LGPL-2.1+"
SLOT="0/2" # libxmlb.so version

KEYWORDS=""
IUSE="doc introspection stemmer test +zstd"

RESTRICT="!test? ( test )"

RDEPEND="
	app-arch/xz-utils
	dev-libs/glib:2
	sys-apps/util-linux
	stemmer? ( dev-libs/snowball-stemmer:= )
	zstd? ( app-arch/zstd:= )
"

DEPEND="
	${RDEPEND}
	doc? ( dev-util/gtk-doc )
	introspection? ( dev-libs/gobject-introspection )
"

BDEPEND="
	${PYTHON_DEPS}
	>=dev-util/meson-0.47.0
	virtual/pkgconfig
	introspection? (
		$(python_gen_any_dep 'dev-python/setuptools[${PYTHON_USEDEP}]')
	)
"

PATCHES=(
	"${FILESDIR}"/${PN}-0.3.13-no_installed_tests.patch
)

python_check_deps() {
	python_has_version -b "dev-python/setuptools[${PYTHON_USEDEP}]"
}

pkg_setup() {
	python-any-r1_pkg_setup
}

src_configure() {
	local emesonargs=(
		$(meson_use doc gtkdoc)
		$(meson_use introspection)
		$(meson_use stemmer)
		$(meson_use test tests)
		$(meson_use zstd)
	)
	meson_src_configure
}
