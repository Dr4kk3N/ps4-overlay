# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Emulator for KC85 and other Z80 based home computers"
HOMEPAGE="
	https://github.com/t-paul/kcemu
	https://kcemu.sourceforge.net/kcemu/about.html
"

if [[ ${PV} == "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/t-paul/kcemu.git"
else
	SRC_URI="https://github.com/t-paul/kcemu/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi

LICENSE="GPL-2+"
SLOT="0"
IUSE="audiofile dirac ffmpeg flac gif lame nls sndfile theora vnc vorbis xvid"

DEPEND="
	dev-libs/z80ex:=
	gui-libs/gtk:=
	media-libs/libsdl2:=
	x11-libs/libX11:=
	x11-libs/libXmu:=
	audiofile? ( media-libs/audiofile:= )
	dirac? ( media-video/dirac:= )
	ffmpeg? ( media-video/ffmpeg:= )
	flac? ( media-libs/flac:= )
	gif? ( media-libs/giflib:= )
	lame? ( media-sound/lame:= )
	sndfile? ( media-libs/libsndfile:= )
	theora? ( media-libs/libtheora:= )
	vnc? ( net-libs/libvncserver:= )
	vorbis? ( media-libs/libvorbis:= )
	xvid? ( media-libs/xvid:= )
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${P}-ncurses.patch"
	"${FILESDIR}/${P}-string.patch"
	"${FILESDIR}/${P}-no-doc.patch"
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		--docdir="${EPREFIX}/usr/share/doc/${PF}" \
		$(use_enable audiofile libaudiofile) \
		$(use_enable dirac libdirac) \
		$(use_enable ffmpeg libavformat) \
		$(use_enable flac libflac) \
		$(use_enable gif libgif) \
		$(use_enable lame libmp3lame) \
		$(use_enable nls) \
		$(use_enable sndfile libsndfile) \
		$(use_enable theora libtheora) \
		$(use_enable vnc libvncserver) \
		$(use_enable vorbis libvorbis) \
		$(use_enable xvid libxvidcore) \
		--disable-libschroedinger \
		--disable-dependency-tracking \
		--disable-rpath \
		--with-ui=gtk
}
