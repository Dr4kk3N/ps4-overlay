# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LIBRETRO_REPO_NAME="libretro/Play-"

inherit libretro-core cmake

DESCRIPTION="Sony Playstation 2 libretro core"
HOMEPAGE="https://github.com/libretro/Play-"
KEYWORDS=""

LICENSE="GPL-3"
SLOT="0"

DEPEND=""
RDEPEND="${DEPEND}
		games-emulation/libretro-info"

S=${S}/Source/ui_libretro

src_configure(){
	local mycmakeargs=(
	-BUILD_LIBRETRO_CORE=ON
	-BUILD_PLAY=OFF
	-DBUILD_TESTS=no
	-DENABLE_AMAZON_S3=no
	-DCMAKE_BUILD_TYPE="Release"
)
	# cmake_src_compile
	libretro-core_src_compile
}
