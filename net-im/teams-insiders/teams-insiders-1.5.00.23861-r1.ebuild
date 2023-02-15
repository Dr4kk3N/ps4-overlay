# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CHROMIUM_LANGS="am ar bg bn ca cs da de el en-GB es es-419 et fa fi fil fr gu he
	hi hr hu id it ja kn ko lt lv ml mr ms nb nl pl pt-BR pt-PT ro ru sk sl sr
	sv sw ta te th tr uk vi zh-CN zh-TW"

inherit chromium-2 desktop unpacker xdg

DESCRIPTION="Microsoft Teams, an Office 365 multimedia collaboration client, Insiders Build"
HOMEPAGE="https://products.office.com/en-us/microsoft-teams/group-chat-software/"
SRC_URI="https://packages.microsoft.com/repos/ms-teams/pool/main/t/${PN}/${PN}_${PV}_amd64.deb"

LICENSE="ms-teams-pre"
SLOT="0"
KEYWORDS="-* ~amd64"
RESTRICT="bindist mirror splitdebug test"
IUSE="swiftshader system-ffmpeg"

QA_PREBUILT="*"

RDEPEND="
	!net-im/teams
	app-accessibility/at-spi2-core:2
	app-accessibility/at-spi2-atk:2
	app-crypt/libsecret
	dev-libs/atk
	dev-libs/expat
	dev-libs/glib
	dev-libs/nspr
	dev-libs/nss
	media-libs/alsa-lib
	media-libs/fontconfig
	media-libs/mesa[gbm(+)]
	net-print/cups
	sys-apps/dbus
	sys-apps/util-linux
	sys-libs/glibc
	x11-libs/cairo
	x11-libs/libdrm
	x11-libs/gdk-pixbuf
	x11-libs/gtk+:3
	x11-libs/libX11
	x11-libs/libXScrnSaver
	x11-libs/libXcomposite
	x11-libs/libXcursor
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXi
	x11-libs/libXrandr
	x11-libs/libXrender
	x11-libs/libXtst
	x11-libs/libxcb
	x11-libs/libxkbfile
	x11-libs/pango
	system-ffmpeg? ( <media-video/ffmpeg-4.3[chromium] )
"

S="${WORKDIR}"

src_prepare() {
	default
	sed -i '/OnlyShowIn=/d' usr/share/applications/${PN}.desktop || die
	sed -e "s@^TEAMS_PATH=.*@TEAMS_PATH=${EPREFIX}/opt/${PN}/${PN}@" \
		-i usr/bin/${PN} || die
}

src_install() {
	rm -r "usr/share/${PN}/resources/assets/"{.gitignore,macos,tlb,windows,x86,x64,arm64} || die
	rm -r "usr/share/${PN}/resources/tmp" || die
	rm "usr/share/${PN}/chrome-sandbox" || die

	insinto /opt
	doins -r usr/share/${PN}

	dobin usr/bin/${PN}
	domenu usr/share/applications/${PN}.desktop
	doicon usr/share/pixmaps/${PN}.png

	pushd "${ED}/opt/${PN}/locales" > /dev/null || die
	chromium_remove_language_paks
	popd > /dev/null || die

	if use system-ffmpeg; then
		rm "${ED}/opt/${PN}/libffmpeg.so" || die
		dosym "../../usr/$(get_libdir)/chromium/libffmpeg.so" "opt/${PN}/libffmpeg.so" || die
		elog "Using system ffmpeg. This is experimental and may lead to crashes."
	fi

	if ! use swiftshader; then
		rm -r "${ED}/opt/${PN}/swiftshader" || die
		elog "Running without SwiftShader OpenGL implementation. If Teams doesn't start "
		elog "or you experience graphic issues, then try with USE=swiftshader enabled."
	fi

	fperms +x /usr/bin/${PN}
	fperms +x /opt/${PN}/${PN}
}
