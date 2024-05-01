# Copyright 2021-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

#PLOCALES="be bg bn ca cs da de el en_GB es et eu fa fi fr gl he hr hu id it ja kk km lg lt nl pl pt pt_BR ro ru si_LK sk sl sr sr@latin sv te tr ug uk vi zh_CN zh_TW"

inherit autotools plocale toolchain-funcs xdg git-r3

DESCRIPTION="DeaDBeeF is a modular audio player similar to foobar2000"
HOMEPAGE="https://deadbeef.sourceforge.io/"
EGIT_REPO_URI="https://github.com/DeadBeeF-Player/${PN}.git"
EGIT_BRANCH="master"

LICENSE="
	GPL-2
	LGPL-2.1
	wavpack? ( BSD )
"
SLOT="0"
KEYWORDS="~amd64 ~riscv ~x86"
IUSE="aac alsa cdda converter cover dts ffmpeg flac +hotkeys lastfm libretro libsamplerate mp3 musepack nls notify +nullout opus oss pipewire pulseaudio sc68 shellexec +supereq vorbis wavpack mac zip"

REQUIRED_USE="
	|| ( alsa oss pulseaudio pipewire nullout )
"

DEPEND="
	>=app-accessibility/at-spi2-core-2.46.0
	dev-libs/glib:2
	dev-libs/jansson:=
	dev-libs/libdispatch
	net-misc/curl
	x11-libs/cairo
	x11-libs/gdk-pixbuf:2
	x11-libs/gtk+:3
	x11-libs/libX11
	x11-libs/pango
	aac? ( media-libs/faad2 )
	alsa? ( media-libs/alsa-lib )
	cdda? (
		dev-libs/libcdio:=
		media-libs/libcddb
		media-sound/cdparanoia
	)
	cover? ( media-libs/imlib2[jpeg,png] )
	dts? ( media-libs/libdca )
	ffmpeg? ( media-video/ffmpeg:= )
	flac? (
		media-libs/flac:=
		media-libs/libogg
	)
	libsamplerate? ( media-libs/libsamplerate )
	mp3? ( media-sound/mpg123 )
	musepack? ( media-sound/musepack-tools )
	nls? ( virtual/libintl )
	notify? ( sys-apps/dbus )
	opus? ( media-libs/opusfile )
	pulseaudio? ( media-libs/libpulse )
	pipewire? ( media-video/pipewire:= )
	vorbis? ( media-libs/libvorbis )
	mac? ( dev-lang/yasm )
	wavpack? ( media-sound/wavpack )
	zip? ( dev-libs/libzip )
	dev-libs/libdispatch:=
"

RDEPEND="${DEPEND}"
BDEPEND="
	dev-util/intltool
	sys-devel/clang
	>=sys-devel/gettext-0.21
	sys-devel/llvm
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}"/${PN}-1.9.6-update-gettext.patch
)

src_prepare() {
	default

	if [[ $(plocale_get_locales disabled) =~ "ru" ]] ; then
		eapply "${FILESDIR}/${P}-remove-ru-help-translation.patch"
		rm -v "${S}/translation/help.ru.txt" || die
	fi

	remove_locale() {
		sed -e "/${1}/d" \
			-i "${S}/po/LINGUAS" || die
	}
	plocale_for_each_disabled_locale remove_locale

	drop_from_linguas() {
		sed "/${1}/d" -i "${S}/po/LINGUAS" || die
	}

	drop_and_stub() {
		einfo drop_and_stub "${1}"
		rm -rf "${1}" || die
		mkdir "${1}" || die
		cat > "${1}/Makefile.in" <<-EOF || die
			all: nothing
			install: nothing
			nothing:
		EOF
	}

	plocale_for_each_disabled_locale drop_from_linguas || die

	drop_and_stub "${S}/intl"

	eautopoint --force
	eautoreconf

	# Get rid of bundled gettext. (Avoid build failures with musl)
	drop_and_stub "${S}/intl"

	# Plugins that are undesired for whatever reason, candidates for unbundling and such.
	for i in adplug alac dumb ffap mms gme lfs mono2stereo psf sc60 shn sid soundtouch wma; do
		drop_and_stub "${S}/plugins/${i}"
	done

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

		"--disable-libmad"
		"--disable-gtk2"
		"--disable-adplug"
		"--disable-coreaudio"
		"--disable-dumb"
		"--disable-alac"
		"--disable-gme"
		"--disable-mms"
		"--disable-mono2stereo"
		"--disable-psf"
		"--disable-rgscanner"
		"--disable-shn"
		"--disable-sid"
		"--disable-sndfile"
		"--disable-soundtouch"
		"--disable-tta"
		"--disable-vtx"
		"--disable-wildmidi"
		"--disable-wma"

		"$(use_enable alsa)"
		"$(use_enable oss)"
		"$(use_enable pulseaudio pulse)"
		"$(use_enable mp3)"
		"$(use_enable mp3 libmpg123)"
		"$(use_enable nls)"
		"$(use_enable vorbis)"
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
		"$(use_enable pulseaudio pulse)"
		"$(use_enable pipewire)"
		"$(use_enable sc68)"
		"$(use_enable shellexec)"
		"$(use_enable shellexec shellexecui)"
		"$(use_enable lastfm lfm)"
		"$(use_enable libretro)"
		"$(use_enable libsamplerate src)"
		"$(use_enable wavpack)"
		"$(use_enable zip vfs-zip)"

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
