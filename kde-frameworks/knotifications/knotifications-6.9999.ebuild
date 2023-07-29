# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_TEST="false"
PVCUT=$(ver_cut 1-2)
QTMIN=6.4.0
inherit ecm frameworks.kde.org

DESCRIPTION="Framework for notifying the user of an event"

LICENSE="LGPL-2.1+"
KEYWORDS=""
IUSE="dbus phonon qml speech X"

RDEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[dbus,gui,widgets]
	=kde-frameworks/kconfig-${PVCUT}*:6
	=kde-frameworks/kcoreaddons-${PVCUT}*:6
	=kde-frameworks/kwindowsystem-${PVCUT}*:6[X?]
	dbus? ( dev-libs/libdbusmenu-qt[qt5(+)] )
	!phonon? ( media-libs/libcanberra )
	phonon? ( >=media-libs/phonon-4.11.0 )
	qml? ( >=dev-qt/qtdeclarative-${QTMIN}:6 )
	speech? ( >=dev-qt/qtspeech-${QTMIN}:6 )
	X? (
		x11-libs/libX11
		x11-libs/libXtst
	)
"
DEPEND="${RDEPEND}
	X? ( x11-base/xorg-proto )
"
BDEPEND=">=dev-qt/qttools-${QTMIN}:6[linguist]"

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package dbus dbusmenu-qt5)
		$(cmake_use_find_package !phonon Canberra)
		$(cmake_use_find_package qml Qt6Qml)
		$(cmake_use_find_package speech Qt6TextToSpeech)
		-DWITHOUT_X11=$(usex !X)
	)

	ecm_src_configure
}
