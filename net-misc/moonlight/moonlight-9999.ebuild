# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

if [[ ${PV} = 9999* ]]; then
	EGIT_REPO_URI="https://github.com/moonlight-stream/moonlight-qt.git"
	EGIT_SUBMODULES=( '*' -libs -soundio )
	inherit git-r3
else
	SRC_URI="https://github.com/moonlight-stream/moonlight-qt/releases/download/v${PV}/MoonlightSrc-${PV}.tar.gz"
	KEYWORDS="~amd64 ~arm64"
	S="${WORKDIR}"
fi

inherit qmake-utils xdg

DESCRIPTION="NVIDIA GameStream (and Sunshine) client"
HOMEPAGE="https://github.com/moonlight-stream/moonlight-qt"
LICENSE="GPL-3"
SLOT="0"
IUSE="cuda +libdrm embedded glslow soundio +vaapi vdpau hdr wayland X"

QT_PV=6.2.0:6 # IDE_QT_VERSION_MIN

RDEPEND="
	dev-libs/openssl:=
	>=dev-qt/qtbase-${QT_PV}=[concurrent,dbus,gui,network,widgets,xml]
	>=dev-qt/qtdeclarative-${QT_PV}=
	>=dev-qt/qtsvg-${QT_PV}=
	media-libs/libglvnd
	media-libs/libpulse
	media-libs/libsdl2[gles2,haptic,kms,joystick,sound,video]
	media-libs/opus
	media-libs/sdl2-ttf
	media-video/ffmpeg:=[cuda?,libdrm?]
	libdrm? ( x11-libs/libdrm )
	soundio? ( media-libs/libsoundio:= )
	vaapi? ( media-libs/libva:=[wayland?,X?] )
	vdpau? (
		x11-libs/libvdpau
		media-libs/libsdl2[X]
	)
	hdr? ( >=media-libs/libplacebo-6.338.2 )
	wayland? ( dev-libs/wayland )
	X? ( x11-libs/libX11 )
"

DEPEND="
	${RDEPEND}
"

BDEPEND="
	dev-qt/qtbase
	virtual/pkgconfig
"

src_prepare() {
	default

	# Force system libsoundio over bundled version.
	rm -r soundio/ || die
}

src_configure() {
	qmake6 PREFIX="${EPREFIX}/usr" CONFIG+=" \
		$(usex cuda "" disable-cuda) \
		$(usex libdrm "" disable-libdrm) \
		--disable-mmal \
		$(usex vaapi "" disable-libva) \
		$(usex vdpau "" disable-libvdpau) \
		$(usex wayland "" disable-wayland) \
		$(usex X "" disable-x11) \
		$(usex hdr "" disable-hdr) \
		$(usev embedded) \
		$(usev glslow) \
		$(usev soundio) \
	"
}

src_install() {
	emake install INSTALL_ROOT="${D}"
	einstalldocs
}
