# Copyright 2021-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

if [[ -z ${PV%%*9999} ]]; then
        inherit git-r3
        EGIT_REPO_URI="https://github.com/DeaDBeeF-Player/${PN}.git"
	EGIT_BRANCH="master"
        EGIT_SUBMODULES=( external/mp4p )
        SRC_URI=""
else
        MY_PV="d2fc9ef"
        MY_MP="mp4p-156195c"
        [[ -n ${PV%%*_p*} ]] && MY_PV="${PV}"
        SRC_URI="
                mirror://githubcl/DeaDBeeF-Player/${PN}/tar.gz/${MY_PV}
                -> ${P}.tar.gz
                mirror://githubcl/DeaDBeeF-Player/${MY_MP%-*}/tar.gz/${MY_MP##*-}
                -> ${MY_MP}.tar.gz
        "
#        RESTRICT="primaryuri"
        KEYWORDS="~amd64 ~riscv ~x86"
        S="${WORKDIR}/${PN}-${MY_PV}"
fi

inherit autotools toolchain-funcs xdg flag-o-matic

DESCRIPTION="DeaDBeeF is a modular audio player similar to foobar2000"
HOMEPAGE="https://deadbeef.sourceforge.io/"
LICENSE="
	GPL-2
	LGPL-2.1
	wavpack? ( BSD )
"
SLOT="0"
IUSE="X aac adplug alac alsa cdda converter cover curl dts dumb ffmpeg flac gme gtk gtk3
+hotkeys lastfm libnotify libretro libsamplerate mac mad mp3 midi mms musepack nls
+nullout opus oss psf pulseaudio pipewire sc68 shellexec shorten sid sndfile threads
tta vorbis +supereq threads vorbis wavpack zip"

REQUIRED_USE="
	lastfm? ( curl )
	|| ( alsa oss pulseaudio pipewire nullout )
"

DEPEND="
	net-misc/curl:=
	dev-libs/jansson:=
	midi? ( media-sound/wildmidi
		media-sound/timidity-freepats
	)
	dumb? ( media-libs/dumb )
	shorten? ( media-sound/shorten )
        alac? ( media-sound/alac_decoder )
	tta? ( media-sound/ttaenc )
	aac? ( media-libs/faad2 )
	alsa? ( media-libs/alsa-lib )
	cdda? (
		dev-libs/libcdio:=
		media-libs/libcddb
		dev-libs/libcdio-paranoia:=
	)
	cover? ( media-libs/imlib2[jpeg,png] )
	dts? ( media-libs/libdca )
	ffmpeg? ( media-video/ffmpeg )
	flac? (
		media-libs/flac:=
		media-libs/libogg
	)
	libsamplerate? ( media-libs/libsamplerate )
	mp3? ( media-sound/mpg123 )
	musepack? ( media-sound/musepack-tools )
	nls? ( virtual/libintl )
	libnotify? ( x11-libs/libnotify
		     sys-apps/dbus )
	oss? ( virtual/libc )
	opus? ( media-libs/opusfile )
	pipewire? ( media-video/pipewire:= )
	pulseaudio? ( media-sound/pulseaudio )
	vorbis? ( media-libs/libvorbis )
	mad? ( media-libs/libmad:= )
	mac? ( media-sound/mac
	       dev-lang/yasm
	)
	sndfile? ( media-libs/libsndfile )
        cdda? ( dev-libs/libcdio media-libs/libcddb )
        gtk? ( x11-libs/gtk+:2 dev-libs/jansson:= )
        gtk3? ( x11-libs/gtk+:3 dev-libs/jansson:= )
        X? ( x11-libs/libX11 )
	wavpack? ( media-sound/wavpack )
	zip? ( dev-libs/libzip )
	dev-libs/libdispatch:=
	gme? ( sys-libs/zlib )
        psf? ( sys-libs/zlib )
"

RDEPEND="${DEPEND}"
BDEPEND="
	dev-util/intltool
	sys-devel/gettext
	sys-devel/clang
	sys-devel/llvm
	virtual/pkgconfig
"

#PATCHES=(
#	"${FILESDIR}/deadbeef-9999-drop-Werror.patch"
#)

PATCHES=( "${FILESDIR}"/adplug.diff )

pkg_setup() {
	if ! tc-is-clang; then
                AR=llvm-ar
                CC=${CHOST}-clang
                CXX=${CHOST}-clang++
                NM=llvm-nm
                RANLIB=llvm-ranlib
                strip-unsupported-flags
        fi
}

src_prepare() {
	default
	if [[ -n ${PV%%*9999} ]]; then
		mv "${WORKDIR}"/${MY_MP}/* "${S}"/external/mp4p
	fi
	local _t=/usr/share/timidity/freepats/timidity.cfg
	sed \
		-e "s,#define DEFAULT_TIMIDITY_CONFIG \",&${_t}:," \
		-i plugins/wildmidi/wildmidiplug.c

	eautopoint --force
	eautoreconf

	# Get rid of bundled gettext.
	use elibc_musl || drop_and_stub "${S}/intl"

	# Plugins that are undesired for whatever reason, candidates for unbundling and such.
#	for i in lfs mono2stereo shn sid soundtouch; do
#		drop_and_stub "${S}/plugins/${i}"
#	done

	rm -rf "${S}/plugins/rg_scanner/ebur128"
}

src_configure () {
	if ! tc-is-clang; then
		AR=llvm-ar
		CC=${CHOST}-clang
		CXX=${CHOST}-clang++
		NM=llvm-nm
		RANLIB=llvm-ranlib

		strip-unsupported-flags
	fi

	export HOST_CC="$(tc-getBUILD_CC)"
	export HOST_CXX="$(tc-getBUILD_CXX)"
	tc-export CC CXX LD AR NM OBJDUMP RANLIB PKG_CONFIG

	local myconf=(
		"--disable-static"
		"--disable-staticlink"
		"--disable-portable"
		"--disable-rpath"

		"($use_enable gtk gtk2)"
		"($use_enable adplug)"
		"($use_enable coreaudio)"
		"($use_enable dumb)"
		"($use_enable alac)"
		"($use_enable gme)"
		"($use_enable mms)"
		"--disable-mono2stereo"
		"($use_enable psf)"
		"--disable-rgscanner"
		"--disable-shn"
		"($use_enable sid)"
		"($use_enable sndfile)"
		"--disable-soundtouch"
		"($use_enable tta)"
		"--disable-vfs-zip"
		"--disable-vtx"
		"($use_enable wildmidi)"
		"($use_enable wma)"

		"$(use_enable alsa)"
		"$(use_enable oss)"
		"$(use_enable pulseaudio pulse)"
		"$(use_enable mp3)"
		"$(use_enable mp3 libmpg123)"
		"$(use_enable nls)"
		"$(use_enable vorbis)"
		"$(use_enable threads)"
		"$(use_enable flac)"
		"$(use_enable supereq)"
		"$(use_enable cdda)"
		"$(use_enable cdda cdda-paranoia)"
		"$(use_enable aac)"
		"$(use_enable cover artwork)"
		"$(use_enable cover artwork-network)"
		"$(use_enable dts dca)"
		"$(use_enable ffmpeg)"
		"$(use_enable converter)"
		"$(use_enable mac ffap)"
		"$(use_enable musepack)"
		"$(use_enable notify)"
		"$(use_enable nullout)"
		"$(use_enable opus)"
		"$(use_enable pipewire)"
		"$(use_enable sc68)"
		"$(use_enable shellexec)"
		"$(use_enable shellexec shellexecui)"
		"$(use_enable lastfm lfm)"
		"$(use_enable libsamplerate src)"
		"$(use_enable wavpack)"

		"--enable-gtk3"
		"--enable-vfs-curl"
		"--enable-shared"
		"--enable-m3u"
		"--enable-pltbrowser"
	)

	econf "${myconf[@]}"
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}
