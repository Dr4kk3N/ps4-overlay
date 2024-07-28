# Copyright 2022 Aisha Tammy <floss@bsd.ac>
# Distributed under the terms of the ISC License

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1

DESCRIPTION="wallpaper setter for Wayland and Xorg window managers.."
HOMEPAGE="https://github.com/anufrievroman/waypaper"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/anufrievroman/waypaper/"
else
	COMMIT="571f495e88cf9a758698d937d65b9ba35d6eab13"
	SRC_URI="https://github.com/anufrievroman/waypaper/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/waypaper-${COMMIT}"
	KEYWORDS="~amd64"
fi

LICENSE="BSD"
SLOT="0"

IUSE="test"
RESTRICT="binchecks strip !test? ( test )"

DEPEND="
	dev-libs/wayland
	media-libs/libglvnd
	media-libs/libjpeg-turbo
	x11-libs/cairo
	x11-libs/pango
	dev-python/pycairo
	dev-python/importlib-metadata
	dev-python/platformdirs
	gui-apps/hyprpaper
"
RDEPEND="
	${DEPEND}
	${DISTUTILS_DEPS}
	${PYTHON_DEPS}
"
BDEPEND="
	${PYTHON_DEPS}
	dev-libs/wayland-protocols
	virtual/pkgconfig
"

DOCS=(
	README.md
)

distutils_enable_tests unittest

python_prepare_all() {
	# don't install manpage
	sed -i '47,49d' setup.py || die

	distutils-r1_python_prepare_all
}

