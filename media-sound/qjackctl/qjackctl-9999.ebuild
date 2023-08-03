# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit xdg cmake git-r3

DESCRIPTION="Qt GUI to control the JACK Audio Connection Kit and ALSA sequencer connections"
HOMEPAGE="https://qjackctl.sourceforge.io/"
EGIT_REPO_URI="https://git.code.sf.net/p/qjackctl/code"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="alsa qt6 dbus debug portaudio"

BDEPEND="dev-qt/linguist-tools:5"
DEPEND="
	!qt6? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtnetwork:5
		dev-qt/qtwidgets:5
		dev-qt/qtx11extras:5
		dev-qt/qtxml:5
	)
	qt6? (
		dev-qt/qtbase:6[X,gui,widgets,network,xml]
	)
	virtual/jack
	alsa? ( media-libs/alsa-lib )
	dbus? (
		!qt6? (
			dev-qt/qtdbus:5=
		)
		qt6? (
			dev-qt/qtbase:6=[dbus]
		)
	)
	portaudio? ( media-libs/portaudio )
"
RDEPEND="${DEPEND}
	!qt6? (
		dev-qt/qtsvg:5=
	)
        qt6? (
                dev-qt/qtsvg:6=
        )
"

src_configure() {
	local mycmakeargs=(
		-DCONFIG_ALSA_SEQ=$(usex alsa 1 0)
		-DCONFIG_DBUS=$(usex dbus 1 0)
		-DCONFIG_DEBUG=$(usex debug 1 0)
		-DCONFIG_PORTAUDIO=$(usex portaudio 1 0)
		-DCONFIG_QT6=$(usex qt6)
	)
	cmake_src_configure
}
