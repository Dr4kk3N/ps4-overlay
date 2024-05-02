# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop optfeature xdg

DESCRIPTION="Minecraft's official launcher"
HOMEPAGE="https://www.minecraft.net/"

MY_SRC_URI_BASE="https://launcher.mojang.com/download"
SRC_URI="
	${MY_SRC_URI_BASE}/linux/x86_64/${PN}_${PV}.tar.gz -> ${P}.tar.gz
	${MY_SRC_URI_BASE}/${PN}.svg
"

LICENSE="Mojang"
SLOT="0"
KEYWORDS="-* ~amd64"
RESTRICT="bindist mirror test"

RDEPEND="
	>=app-accessibility/at-spi2-core-2.9.90:2
	app-accessibility/orca
	app-crypt/libsecret
	>=dev-libs/expat-2.0.1
	>=dev-libs/glib-2.39.4:2
	>=dev-libs/nspr-4.9.2
	>=dev-libs/nss-3.22
	>=media-libs/alsa-lib-1.0.23
	>=media-libs/mesa-8.1
	>=net-print/cups-1.4.0
	>=sys-apps/dbus-1.5.12
	virtual/secret-service
	>=x11-libs/gdk-pixbuf-2.22.0:2
	>=x11-libs/gtk+-3.18.9:3
	>=x11-libs/libdrm-2.4.38
	>=x11-libs/libX11-1.4.99.1
	>=x11-libs/libxcb-1.1:*
	>=x11-libs/libXcomposite-0.3
	>=x11-libs/libXdamage-1.1
	x11-libs/libXext
	x11-libs/libXfixes
	>=x11-libs/libXrandr-1.2.99.3
	>=x11-libs/pango-1.14.0
"

S="${WORKDIR}/${PN}"
QA_PREBUILT="opt/bin/${PN}"

src_install() {
	exeinto "/opt/bin"
	doexe "${PN}"

	doicon -s scalable "${DISTDIR}/${PN}.svg"
	make_desktop_entry "${PN}" "Minecraft launcher" "${PN}" \
		"ActionGame;AdventureGame;Game;Java" \
		"StartupWMClass=${PN}"
}

pkg_postinst() {
	xdg_pkg_postinst

	optfeature "narrator support" app-accessibility/flite
}
