# Copyright 1999-2022 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10,11} )

inherit cmake flag-o-matic python-single-r1

DESCRIPTION="plain-C Protocol Buffers for embedded/memory-constrained systems"
HOMEPAGE="https://jpa.kapsi.fi/nanopb/ https://github.com/nanopb/nanopb"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/nanopb/nanopb.git"
else
	SRC_URI="https://github.com/nanopb/nanopb/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 x86"
fi

LICENSE="ZLIB"
SLOT="0"
IUSE="+pb-malloc"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	dev-libs/protobuf
	${PYTHON_DEPS}
"
DEPEND="
	dev-build/scons
	${RDEPEND}
"
BDEPEND="${PYTHON_DEPS}"

#S="${WORKDIR}/${PN}-${PV}"

src_configure() {
	use pb-malloc && append-cppflags "-DPB_ENABLE_MALLOC"
	cmake_src_configure
}

src_test() {
	cd "${S}"/tests
	scons
}

src_install() {
	cmake_src_install
	python_optimize
}
