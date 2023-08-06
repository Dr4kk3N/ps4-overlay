# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit ninja-utils

DESCRIPTION="OpenGL audio spectrum visualizer"
HOMEPAGE="https://github.com/jarcode-foss/glava"
SRC_URI="https://github.com/jarcode-foss/glava/archive/master.tar.gz -> ${PN}-master.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="
	debug
	glfw
	obs
"

DEPEND="
	media-sound/pulseaudio
	x11-libs/libXcomposite
	x11-libs/libXext
	x11-libs/libXrender
"
RDEPEND="${DEPEND}"
BDEPEND="
	dev-lang/lua
	dev-lua/lgi
	dev-lua/luafilesystem
	dev-util/meson
	x11-libs/gtk+:3
	glfw? ( media-libs/glfw )
	obs? ( media-video/obs-studio )
"

src_unpack() {
	unpack "${A}"
	mv "${PN}-master" "${P}"
}

src_configure() {
	meson build \
		--prefix="${D}/usr" \
		-Ddisable_obs=$(usex obs false true) \
		-Denable_glfw=$(usex glfw true false) \
		-Dbuildtype=$(usex debug debug release)
}

src_compile() {
	eninja -C build
}

src_install() {
	# Manually installing all files, since changing the directory options in
	# meson during configure will also cause the built binaries to use the
	# temporary portage sandbox paths.

	# Headers
	doheader "${PN}/${PN}.h"

	# Libs
	dolib.so "build/lib${PN}.so"

	# Resources
	insinto "/usr/share/${PN}"
	doins -r resources
	insinto "/etc/xdg/${PN}"
	doins -r "shaders/${PN}"/*

	# Binaries
	dobin "build/${PN}"
}
