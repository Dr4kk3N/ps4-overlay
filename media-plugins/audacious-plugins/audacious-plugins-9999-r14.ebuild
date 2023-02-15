# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_P="${P/_/-}"
S="${WORKDIR}/${MY_P}"
DESCRIPTION="Audacious Player - Your music, your way, no exceptions"
HOMEPAGE="https://audacious-media-player.org/"

if [[ ${PV} == "9999" ]]; then
	EGIT_REPO_URI="https://github.com/audacious-media-player/${PN}.git"
	inherit git-r3
else
	KEYWORDS="~amd64 ~x86"
	SRC_URI="https://distfiles.audacious-media-player.org/${MY_P}.tar.bz2"
fi

inherit meson

# build system: BSD-2
# embedded libgme, adplug: LGPL-2.1
# other internal console players, most plugins: GPL-2+
# GUI is GPL-3 only: src/skins/main.h is explicit about it.
LICENSE="
	BSD-2
	LGPL-2.1
	GPL-2+
	ampache? ( GPL-3 )
	flac? ( GPL-3+ )
	gtk? ( GPL-3 )
	gtk3? ( GPL-3 )
	libnotify? ( GPL-3+ )
	qt5? ( GPL-3 )"
SLOT="0"

# These are split up roughly by how upstream organises them, except the NEED_* lists
USE_FRONTENDS="mpris2 gtk gtk3 +qt5 moonstone"
USE_CONTAINERS="cue"
USE_TRANSPORTS="mms http"
USE_INPUTS="aac adplug cdda ffmpeg fluidsynth +gme modplug mp3 openmpt opus sid sndfile wavpack"
USE_CODECS="flac lame vorbis" # filewriter codecs, flac/vorbis are also input
USE_OUTPUTS="+alsa coreaudio encode jack oss pipewire pulseaudio qtmedia sdl sndio"

NEED_GUI="+hotkeys libnotify opengl"
NEED_GTK="aosd lirc" # XXX 2021-02-02 lirc's dep is currently automagic
NEED_QT5="ampache moonstone qtmedia streamtuner +vumeter"

IUSE="bs2b libsamplerate scrobbler +songchange soxr xml
	${USE_FRONTENDS} ${USE_CONTAINERS} ${USE_TRANSPORTS}
	${USE_INPUTS} ${USE_OUTPUTS} ${USE_CODECS}
	${NEED_GUI} ${NEED_GTK} ${NEED_QT5}"

# this is verbose, but it makes user-facing errors more scrutable
REQUIRED_USE="
	|| ( ${USE_FRONTENDS//+/} )
	|| ( ${USE_OUTPUTS//+/} )
	encode?    ( || ( ${USE_CODECS//+/} ) )
	scrobbler? ( xml )
	$(for flag in ${NEED_GUI//+/}; do printf '%s?\t( || ( gtk qt5 ) )\n' "$flag"; done)
	$(for flag in ${NEED_GTK//+/}; do printf '%s?\t( gtk )\n' "$flag"; done)
	$(for flag in ${NEED_QT5//+/}; do printf '%s?\t( qt5 )\n' "$flag"; done)
"

# hotkeys currently has automagic detection
QT_REQ="5.4:5="
RDEPEND="
	>=dev-libs/glib-2.32
	>=media-sound/audacious-4.1:=[qt5(-)=,gtk(-)=,gtk3(-)=]
	sys-libs/zlib
	aac? ( >=media-libs/faad2-2.7 )
	adplug? ( media-libs/adplug )
	alsa? ( >=media-libs/alsa-lib-1.0.16 )
	ampache? ( media-libs/ampache_browser )
	bs2b? ( >=media-libs/libbs2b-3.0.0 )
	cdda? (
		>=dev-libs/libcdio-0.70:=
		>=dev-libs/libcdio-paranoia-0.70:=
		>=media-libs/libcddb-1.2.1
	)
	cue? ( >=media-libs/libcue-2.0 )
	ffmpeg? ( >=media-video/ffmpeg-4.2.4 )
	flac? ( >=media-libs/flac-1.2.1[ogg] )
	fluidsynth? ( >=media-sound/fluidsynth-1.0.6:= )
	gtk? (
		>=x11-libs/gtk+-2.24:2
		aosd? (
			x11-libs/libXrender
			x11-libs/libXcomposite
		)
		lirc? ( app-misc/lirc )
		opengl? ( virtual/opengl )
	)
	gtk3? (
		>=x11-libs/gtk+-3.22:3
		aosd? (
			x11-libs/libXrender
			x11-libs/libXcomposite
		)
		lirc? ( app-misc/lirc )
		opengl? ( virtual/opengl )
	)
	http? ( >=net-libs/neon-0.27 )
	jack? ( virtual/jack )
	qt5? (
		>=dev-qt/qtcore-${QT_REQ}
		>=dev-qt/qtgui-${QT_REQ}
		>=dev-qt/qtwidgets-${QT_REQ}
		hotkeys? ( >=dev-qt/qtx11extras-${QT_REQ} )
		opengl? ( >=dev-qt/qtopengl-${QT_REQ} )
		qtmedia? ( >=dev-qt/qtmultimedia-${QT_REQ} )
		streamtuner? ( >=dev-qt/qtnetwork-${QT_REQ} )
	)
	lame? ( media-sound/lame )
	libnotify? (
		>=x11-libs/libnotify-0.7
		>=x11-libs/gdk-pixbuf-2.26
	)
	libsamplerate? ( media-libs/libsamplerate:= )
	mms? ( >=media-libs/libmms-0.3 )
	modplug? ( media-libs/libmodplug )
	mp3? ( >=media-sound/mpg123-1.12 )
	openmpt? ( >=media-libs/libopenmpt-0.2 )
	opus? (
		>=media-libs/opus-1.0.1
		>=media-libs/opusfile-0.4
	)
	pipewire? ( >=media-video/pipewire-0.3.26 )
	pulseaudio? ( >=media-sound/pulseaudio-0.9.5 )
	scrobbler? ( net-misc/curl )
	sdl? ( media-libs/libsdl2 )
	sid? ( >=media-libs/libsidplayfp-2.0 )
	sndfile? ( >=media-libs/libsndfile-1.0.19 )
	sndio? ( media-sound/sndio )
	soxr? ( media-libs/soxr )
	vorbis? (
		>=media-libs/libogg-1.0
		>=media-libs/libvorbis-1.0
	)
	wavpack? ( >=media-sound/wavpack-4.31 )
	xml? ( dev-libs/libxml2:2 )"

DEPEND="${RDEPEND} virtual/pkgconfig"
BDEPEND="
	sys-devel/gettext
	mpris2? ( dev-util/gdbus-codegen )"

PATCHES=(
	# CVE-2017-17446; https://bitbucket.org/mpyne/game-music-emu/issues/14
	"${FILESDIR}"/0001-nsfe-Sanity-check-block-header-size-before-reading.patch
	"${FILESDIR}"/0002-nsfe-Add-some-additional-hardening-and-sanity-checks.patch
)

src_configure() {
	# As above for IUSE, grouped by how upstream organises them
	local emesonargs=(
		# GUI toolkits
		"$(meson_use "$(usex gtk3 gtk3 gtk)" gtk)"
		"$(meson_use            gtk3)"
		"$(meson_use qt5        qt)"

		# container plugins
		"$(meson_use            cue)"

		# transport plugins
		"$(meson_use            mms)"
		"$(meson_use http       neon)"

		# input plugins
		"$(meson_use            aac)"
		"$(meson_use            adplug)"
		"$(meson_use fluidsynth amidiplug)"
		"$(meson_use cdda       cdaudio)"
		"$(meson_use gme        console)"
		"$(meson_use ffmpeg     ffaudio)"
		"$(meson_use            flac)"
		"$(meson_use            modplug)"
		"$(meson_use mp3        mpg123)"
		"$(meson_use            openmpt)"
		"$(meson_use            opus)"
		"$(meson_use            sid)"
		"$(meson_use            sndfile)"
		"$(meson_use            vorbis)"
		"$(meson_use            wavpack)"

		# output plugins
		"$(meson_use            alsa)"
		"$(meson_use            coreaudio)"
		"$(meson_use encode     filewriter)"
		"$(meson_use flac       filewriter-flac)"
		"$(meson_use lame       filewriter-mp3)"
		"$(meson_use vorbis     filewriter-ogg)"
		"$(meson_use            jack)"
		"$(meson_use            oss)"
		"$(meson_use pulseaudio pulse)"
		"$(meson_use qtmedia    qtaudio)"
		"$(meson_use sdl        sdlout)"
		"$(meson_use            sndio)"

		# general plugins
		"$(meson_use            ampache)"
		"$(meson_use            aosd)"
		"$(meson_use hotkeys    hotkey)"
		"$(meson_use            lirc)"
		"$(meson_use            mpris2)"
		"$(meson_use libnotify  notify)"
		"$(meson_use scrobbler  scrobbler2)"
		"$(meson_use            songchange)"
		"$(meson_use            streamtuner)"

		# effect plugins
		"$(meson_use            bs2b)"
		"$(meson_use libsamplerate resample)"
		"$(meson_use            soxr)"
		"$(meson_use libsamplerate speedpitch)"

		# visualisation plugins
		"$(meson_use opengl     gl-spectrum)"
		"$(meson_use            vumeter)"

		# interface plugins
		"$(meson_use            moonstone)"
	)
	meson_src_configure
}

pkg_postinst() {
	if ! has_version -r app-arch/unzip; then
		einfo "For full winamp2 skin support either install app-arch/unzip,"
		einfo "or set the environment variable UNZIPCMD to a drop-in replacement"
		einfo "(e.g. 'busybox unzip')"
	fi
}
