# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop linux-info optfeature xdg

MY_PN="${PN^}"

DESCRIPTION="All-in-one voice and text chat for gamers"
HOMEPAGE="https://discord.com/"
SRC_URI="https://dl.discordapp.net/apps/linux/${PV}/${P}.tar.gz"
LICENSE="Discord-TOS"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="bindist mirror"

RDEPEND="
	app-accessibility/at-spi2-atk:2
	app-accessibility/at-spi2-core:2
	dev-libs/atk
	dev-libs/expat
	dev-libs/glib:2[dbus]
	dev-libs/nspr
	dev-libs/nss
	media-libs/alsa-lib
	media-libs/mesa[gbm(+)]
	net-print/cups
	sys-apps/dbus
	x11-libs/cairo
	x11-libs/gdk-pixbuf:2
	x11-libs/gtk+:3[X,cups]
	x11-libs/libdrm
	x11-libs/libX11
	x11-libs/libxcb:*
	x11-libs/libXcomposite
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libxkbcommon
	x11-libs/libXrandr
	x11-libs/libxshmfence
	x11-libs/pango
"

QA_PREBUILT="
	opt/${PN}/${MY_PN}
	opt/${PN}/chrome-sandbox
	opt/${PN}/libEGL.so
	opt/${PN}/libffmpeg.so
	opt/${PN}/libGLESv2.so
	opt/${PN}/libvk_swiftshader.so
	opt/${PN}/swiftshader/libEGL.so
	opt/${PN}/swiftshader/libGLESv2.so
"

S="${WORKDIR}/${MY_PN}"
CONFIG_CHECK="USER_NS"

src_prepare() {
	default

	sed \
		-e "s|/usr/share/discord/Discord|${PN}|g" \
		-e "/^Path=/d" \
		"${PN}.desktop" \
		> "${T}/${PN}.desktop" \
		|| die
}

src_install() {
	local -r dir="/opt/${PN}"

	doicon -s 256 "${PN}.png"
	domenu "${T}/${PN}.desktop"

	rm "${PN}.desktop" "${PN}.png" postinst.sh || die "The cleaning has failed"

	dodir "${dir}"
	cp -a * "${D}/${dir}" || die
	dosym "../${PN}/${MY_PN}" "/opt/bin/${PN}"
}

pkg_postinst() {
	xdg_pkg_postinst

	optfeature "sound support" \
		media-sound/pulseaudio media-sound/apulse[sdk] media-video/pipewire

	optfeature "system tray support" dev-libs/libappindicator:3
}
