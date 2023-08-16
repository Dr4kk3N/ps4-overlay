# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LIBRETRO_REPO_NAME="libretro/bsnes-mercury"

inherit libretro-core

DESCRIPTION="Libretro fork of bsnes"
HOMEPAGE="https://github.com/libretro/bsnes-mercury"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
# No tests provided
RESTRICT="test"

src_compile(){
	mymakeargs="profile=performance"
		libretro-core_src_compile
}

src_install() {
	libretro-core_src_install
}
