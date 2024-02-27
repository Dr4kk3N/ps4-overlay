# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
# $Id: 77337142ec368ef43c179461f5ca0beb09d5cd21 $

EAPI=7

inherit cmake desktop

DESCRIPTION="Advanced DRI Configurator"
HOMEPAGE="https://gitlab.freedesktop.org/mesa/adriconf"
if [[ "${PV}" == 9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://gitlab.freedesktop.org/mesa/adriconf.git"
else
	SRC_URI="https://gitlab.freedesktop.org/mesa/${PN}/-/archive/v${PV}/adriconf-v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi
LICENSE="GPL-3"
SLOT="0"

IUSE="wayland"

RDEPEND="
	dev-cpp/glibmm:2
	dev-cpp/gtkmm:3.0
	dev-cpp/libxmlpp
	dev-libs/boost:=
	dev-libs/glib:2
	dev-libs/libsigc++:2
	media-libs/mesa
	sys-apps/pciutils
	x11-libs/gtk+:3
	x11-libs/libdrm
	x11-libs/libX11
	wayland? ( media-libs/mesa )
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig
"

S="${WORKDIR}/${PN}-v${PV}"

src_prepare() {
	cmake_src_prepare
	sed '/^Version/d' -i flatpak/org.freedesktop.${PN}.desktop || die
	if [[ "${PV}" != 9999 ]] ; then
		sed "/aboutDialog\.set_version/s@1\.0\.0@${PV}@" \
			-i adriconf/GUI.cpp || die
	fi
}

src_configure() {
	local mycmakeargs=(
		-DENABLE_UNIT_TESTS="false"
		-DENABLE_XWAYLAND="$(usex wayland)"
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install

	insinto /usr/share/appdata
	newins {flatpak/org.freedesktop.,}${PN}.metainfo.xml

	newmenu {flatpak/org.freedesktop.,}${PN}.desktop

	newicon {flatpak/org.freedesktop.,}${PN}.png
}
