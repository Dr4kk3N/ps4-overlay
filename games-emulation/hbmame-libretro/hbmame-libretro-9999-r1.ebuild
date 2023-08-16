# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LIBRETRO_REPO_NAME="libretro/hbmame-libretro"

inherit libretro-core

DESCRIPTION="Emulator of homebrew and hacked games for arcade hardware"
HOMEPAGE="https://github.com/libretro/hbmame-libretro"
KEYWORDS=""

LICENSE="MAME"
SLOT="0"

DEPEND=""
RDEPEND="${DEPEND}
		games-emulation/libretro-info"

src_configure() {
	emake -f Makefile.libretro PYTHON_EXECUTABLE=python3 REGENIE=0 VERBOSE=0 NOWERROR=0
}
