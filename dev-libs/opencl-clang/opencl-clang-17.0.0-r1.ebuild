# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LLVM_MAX_SLOT="17"

inherit cmake llvm

DESCRIPTION="OpenCL-oriented thin wrapper library around clang"
HOMEPAGE="https://github.com/intel/opencl-clang"
SRC_URI="https://github.com/intel/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${PV}"

LICENSE="UoI-NCSA"
SLOT="$(ver_cut 1)"
KEYWORDS="amd64 ~riscv"

RDEPEND="
	dev-util/spirv-llvm-translator:${SLOT}=
	sys-devel/clang:${SLOT}=[static-analyzer]
	sys-devel/llvm:${SLOT}=
"

DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-17.0.6-base_llvm_version.patch
	"${FILESDIR}"/${PN}-17.0.6-clang_library_dir.patch
)

src_configure() {
	local mycmakeargs=(
		-DCLANG_LIBRARY_DIRS="${EPREFIX}"/usr/lib
		-DCMAKE_INSTALL_PREFIX="$(get_llvm_prefix ${LLVM_MAX_SLOT})"
		-Wno-dev
	)

	cmake_src_configure
}
