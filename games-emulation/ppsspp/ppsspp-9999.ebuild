# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )
FFMPEG_VERSION="4.4.4-r4"

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://github.com/hrydgard/ppsspp.git"
	inherit git-r3

else
	SRC_URI="https://github.com/hrydgard/${PN}/releases/download/v${PV}/${P}.tar.xz"
	KEYWORDS="amd64"
fi

inherit autotools python-any-r1 xdg cmake

DESCRIPTION="A PSP emulator written in C++"
HOMEPAGE="https://www.ppsspp.org/
	https://github.com/hrydgard/ppsspp/"

LICENSE="Apache-2.0 BSD BSD-2 GPL-2 JSON MIT"
SLOT="0"
IUSE="discord qt5 system-ffmpeg"
RESTRICT="test"

DEPEND="
	app-arch/snappy:=
        app-arch/zstd:=
        dev-libs/libzip:=
        media-libs/glew:=
        media-libs/libpng:=
        media-libs/libsdl2[joystick]
        sys-libs/zlib:=
        qt5? (
                dev-qt/qtcore:5
                dev-qt/qtgui:5[-gles2-only]
                dev-qt/qtmultimedia:5[-gles2-only]
                dev-qt/qtopengl:5[-gles2-only]
                dev-qt/qtwidgets:5[-gles2-only]
        )
	!qt5? ( media-libs/libsdl2[X,opengl,sound,video] )
"

RDEPEND="
	${DEPEND}
	virtual/opengl
"

BDEPEND="${PYTHON_DEPS}"

PATCHES=(
	"${FILESDIR}"/${PN}-CMakeLists-flags.patch
	"${FILESDIR}"/${PN}-disable-ccache-autodetection.patch
)

pkg_setup() {
	python-any-r1_pkg_setup
}

src_configure() {
	local -a mycmakeargs=(
		-DBUILD_SHARED_LIBS=OFF
		-DCMAKE_SKIP_RPATH=ON
		-DHEADLESS=false
		-DUSE_SYSTEM_FFMPEG=$(usex system-ffmpeg)
		-DUSE_SYSTEM_LIBZIP=ON
		-DUSE_SYSTEM_SNAPPY=ON
		-DUSE_SYSTEM_ZSTD=ON
		-DUSE_DISCORD=$(usex discord)
		-DUSING_QT_UI=$(usex qt5)
	)

	if use system-ffmpeg; then
                mycmakeargs+=( -DWITH_FFMPEG="yes" )
        else
            	mycmakeargs+=( -DFFMPEG_URL="${DISTDIR}/ffmpeg-${PN}-${FFMPEG_VERSION}-${CODENAME}-${FFMPEG_KODI_VERSION}.tar.gz" )
        fi

	cmake_src_configure
}
