# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=7

inherit cmake

MY_PN="ROCR-Runtime"
MY_PV="roc-${PV}"

DESCRIPTION="Radeon Open Compute HSA Runtime"
HOMEPAGE="http://gpuopen.com/professional-compute/rocm/"
SRC_URI="https://github.com/RadeonOpenCompute/${MY_PN}/archive/${MY_PV}.tar.gz -> ${MY_PN}-${MY_PV}.tar.gz"

LICENSE="NCSA"

SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="=dev-libs/hsathk-amd-${PV}"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${MY_PN}-${MY_PV}"

CMAKE_USE_DIR="${S}/src"

src_configure() {
	local mycmakeargs=(
		-DHSATHK_BUILD_INC_PATH=/usr/include/hsathk
		-DHSATHK_BUILD_LIB_PATH=/usr/$(get_libdir)
	)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	insinto /usr/include/hsa
	doins src/inc/amd_hsa_* src/inc/hsa_ext_* src/inc/hsa.h
}
