# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake xdg-utils

DESCRIPTION="a multi-system chiptune tracker compatible with DefleMask modules"
HOMEPAGE="https://github.com/tildearrow/furnace/"

if [[ ${PV} == 9999 ]]; then
        inherit git-r3
	EGIT_REPO_URI="https://github.com/tildearrow/furnace.git"
	EGIT_SUBMODULES=( "extern/adpcm" )
else
# when performing updates, check whether the project has switched to a new
# version of adpcm. adpcm doesn't seem to update frequently.
	SRC_URI="
		https://github.com/tildearrow/furnace/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
        	https://github.com/superctr/adpcm/archive/ef7a217154badc3b99978ac481b268c8aab67bd8.tar.gz -> ${P}-adpcm-ef7a217.tar.gz
	"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="jack"

RDEPEND="
	jack? ( virtual/jack )
	dev-libs/libfmt
	media-libs/alsa-lib
	media-libs/libsdl2
	media-libs/libsndfile
	media-libs/portaudio
	media-libs/mesa
	media-libs/rtmidi
	media-sound/pulseaudio
	x11-themes/hicolor-icon-theme
	sci-libs/fftw
	sys-libs/zlib
"

DEPEND="${RDEPEND}"

src_configure() {
    # -DSYSTEM_FREETYPE=ON does not work
    local mycmakeargs=(
		-DBUILD_GUI=ON
		-DSYSTEM_FREETYPE=ON
		-DSYSTEM_FFTW=ON
		-DSYSTEM_FMT=ON
		-DSYSTEM_LIBSNDFILE=ON
		-DSYSTEM_PORTAUDIO=ON
		-DSYSTEM_RTMIDI=ON
		-DSYSTEM_ZLIB=ON
		-DSYSTEM_SDL2=ON
		-DWITH_JACK="$(usex jack)"
    )
    cmake_src_configure
}

pkg_postinst() {
        xdg_icon_cache_update
}

pkg_postrm() {
        xdg_icon_cache_update
}
