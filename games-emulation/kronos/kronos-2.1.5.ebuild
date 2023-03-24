# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake multiprocessing

U_PN="${PN^}"

DESCRIPTION="Sega Saturn emulator.  Fork of YabaSanshiro/Yabause."
HOMEPAGE="https://github.com/FCare/Kronos"
SRC_URI="https://github.com/FCare/${U_PN}/archive/${PV}_official_release.tar.gz"

S="$WORKDIR/${U_PN}-${PV}_official_release"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""


CMAKE_USE_DIR="${S}/yabause"

src_prepare() {
	cmake_src_prepare
	use amd64 && eapply "${FILESDIR}/${PV}-lib64.patch"
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=OFF
		# Hopefully upstream implements GNUInstallDirs for cmake
		# so we can use this someday instead of the stupid lib64 patch
		# -DLIB_INSTALL_DIR="$(get_libdir)"
	)
	cmake_src_configure
}

src_compile() {
	if [ -f Makefile ] || [ -f GNUmakefile ] || [ -f makefile ]; then
		emake -j $(makeopts_jobs) || die "emake failed"
	fi
}
