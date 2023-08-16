# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LIBRETRO_REPO_NAME="libretro/FFmpeg"

inherit libretro-core

DESCRIPTION="FFmpeg frontend for libretro"
HOMEPAGE="https://github.com/libretro/FFmpeg"
KEYWORDS=""

LICENSE="LGPL-2.1 GPL-2 GPL-3 LGPL-3"

SLOT="0"

DEPEND="media-video/ffmpeg
	media-libs/libass"

RDEPEND="${DEPEND}
		games-emulation/libretro-info"

S="${S}/libretro"
