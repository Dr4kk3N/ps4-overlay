# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

#: ${CMAKE_MAKEFILE_GENERATOR:=emake}
inherit cmake xdg-utils

MY_PV="${PV/_rc/-rc.}"
MY_P="SuperTux-v${MY_PV}-Source"

DESCRIPTION="A game similar to Super Mario Bros"
HOMEPAGE="https://www.supertux.org"

if [[ ${PV} == 9999 ]]; then
        inherit git-r3
	EGIT_REPO_URI="https://github.com/SuperTux/supertux.git"
	EGIT_SUBMODULES=( "external/SDL_SavePNG"
			  "external/SDL_ttf"
			  "external/discord-sdk"
			  "external/findlocale"
			  "external/obstack"
			  "external/partio_zip"
			  "external/sexp-cpp"
			  "external/simplesquirrel"
			  "external/simplesquirrel/libs/squirrel"
			  "external/tinygettext"
			)
else
	SRC_URI="https://github.com/SuperTux/${PN}/releases/download/v${MY_PV}/${MY_P}.tar.gz"
	S="${WORKDIR}/${MY_P}"
	KEYWORDS="~amd64 ~arm64 ~x86"
fi

LICENSE="GPL-2+ GPL-3+ ZLIB MIT CC-BY-SA-2.0 CC-BY-SA-3.0"
SLOT="0"
IUSE="debug"

# =media-libs/libsdl2-2.0.14-r0 can cause supertux binary to move entire
# content of ${HOME} to ${HOME}/.local/share/supertux2/
# DO NOT REMOVE THIS BLOCKER!!! See bug #764959
RDEPEND="
	!=media-libs/libsdl2-2.0.14-r0
	>=dev-games/physfs-3.0
	dev-libs/boost:=[nls]
	media-libs/freetype
	media-libs/glew:=
	media-libs/libpng:0=
	>=media-libs/libsdl2-2.0.1[joystick,video]
	media-libs/libvorbis
	media-libs/openal
	>=media-libs/sdl2-image-2.0.0[png,jpeg]
	>=net-misc/curl-7.21.7
	virtual/opengl
	>=dev-libs/libraqm-0.10.1
"
DEPEND="${RDEPEND}
	media-libs/glm"
BDEPEND="
	virtual/pkgconfig
"

#PATCHES=(
#	"${FILESDIR}"/${PN}-0.6.3-missing-include.patch
#)

#	"${FILESDIR}"/${PN}-0.5.0-tinygettext.patch
#	"${FILESDIR}"/${PN}-0.6.0-{license,icon,obstack}.patch
#	"${FILESDIR}"/${PN}-0.6.3-squirrel-CVE-2021-41556.patch
#       "${FILESDIR}"/${PN}-0.6.3-squirrel-CVE-2022-30292.patch

src_prepare() {
   default
   #  usr/lib/libsimplesquirrel.so
   sed -i "s|SET(LIB_INSTALL_DIR \"lib\/\"|SET(LIB_INSTALL_DIR \"$(get_libdir)/\"|" external/simplesquirrel/libs/squirrel/CMakeLists.txt
   cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DWERROR=OFF
		-DINSTALL_SUBDIR_BIN=bin
		-DINSTALL_SUBDIR_DOC=share/doc/${PF}
		-DINSTALL_SUBDIR_SHARE=share/${PN}2
		-DENABLE_SQDBG="$(usex debug)"
		-DUSE_SYSTEM_PHYSFS=ON
		-DIS_SUPERTUX_RELEASE=ON
		-DBUILD_SHARED_LIBS=OFF
	)
	cmake_src_configure
}

pkg_postinst() {
        xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}

