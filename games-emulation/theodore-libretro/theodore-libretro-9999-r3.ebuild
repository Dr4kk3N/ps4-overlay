# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LIBRETRO_REPO_NAME="Zlika/theodore"
LIBRETRO_CORE_NAME="theodore"

inherit libretro-core

DESCRIPTION="Libretro core for Thomson TO8/TO8D/TO9/TO9+ emulation."
HOMEPAGE="https://github.com/Zlika/theodore"
KEYWORDS=""

LICENSE="GPL-3"
SLOT="0"

DEPEND=""
RDEPEND="${DEPEND}
		games-emulation/libretro-info"

