# Copyright 2021 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LIBRETRO_REPO_NAME="libretro/dosbox-svn"

inherit libretro-core

DESCRIPTION="DOSBox libretro core"
HOMEPAGE="https://github.com/libretro/dosbox-svn"
KEYWORDS=""

LICENSE="GPL-2+"
SLOT="0"

DEPEND="media-libs/libinstpatch
		media-libs/sdl-net
		media-libs/munt-mt32emu
		media-sound/munt-mt32emu-alsadrv
		media-libs/flac
		media-sound/fluidsynth
		dev-libs/libfmt
		dev-libs/glib
		dev-libs/libffi
		media-libs/libsndfile
		media-libs/libogg
		media-libs/opus
		media-libs/libsdl
		media-libs/libvorbis
		"
RDEPEND="${DEPEND}
		games-emulation/libretro-info"

S="${S}/libretro"

src_compile() {
		libretro-core_src_compile
}
