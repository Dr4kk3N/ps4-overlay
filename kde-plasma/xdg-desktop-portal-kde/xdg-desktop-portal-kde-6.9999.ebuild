# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_TEST="forceoptional"
KFMIN=5.240.0
PVCUT=$(ver_cut 1-3)
QTMIN=4.6.2
inherit ecm plasma.kde.org

DESCRIPTION="Backend implementation for xdg-desktop-portal that is using Qt/KDE Frameworks"

LICENSE="LGPL-2+"
SLOT="6"
KEYWORDS=""
IUSE=""

# dev-qt/qtgui: QtXkbCommonSupport is provided by either IUSE libinput or X
COMMON_DEPEND="
	>=dev-libs/wayland-1.15
	>=dev-qt/qtbase-${QTMIN}:6[dbus]
	>=dev-qt/qtdeclarative-${QTMIN}:6
	|| (
		>=dev-qt/qtbase-${QTMIN}:6[libinput]
		>=dev-qt/qtbase-${QTMIN}:6[X]
	)
	>=dev-qt/qtbase-${QTMIN}:6[cups]
	>=dev-qt/qtwayland-${QTMIN}:6
	>=dev-qt/qtbase-${QTMIN}:6[widgets]
	>=kde-frameworks/kcoreaddons-${KFMIN}:6[dbus]
	>=kde-frameworks/kconfig-${KFMIN}:6
	>=kde-frameworks/kdeclarative-${KFMIN}:6
	>=kde-frameworks/kglobalaccel-${KFMIN}:6
	>=kde-frameworks/kguiaddons-${KFMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
	>=kde-frameworks/kiconthemes-${KFMIN}:6
	>=kde-frameworks/kio-${KFMIN}:6
	>=kde-frameworks/kirigami-${KFMIN}:6
	>=kde-frameworks/knotifications-${KFMIN}:6
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:6
	>=kde-frameworks/kwindowsystem-${KFMIN}:6
	>=kde-frameworks/kwayland-${KFMIN}:6
	>=kde-frameworks/plasma-${KFMIN}:6
	x11-libs/libxkbcommon
"
DEPEND="${COMMON_DEPEND}
	>=dev-libs/plasma-wayland-protocols-1.7.0
	>=dev-libs/wayland-protocols-1.25
	>=dev-qt/qtbase-${QTMIN}:6[concurrent]
"
RDEPEND="${COMMON_DEPEND}
	kde-misc/kio-fuse:5
	sys-apps/xdg-desktop-portal
"
BDEPEND="
	virtual/pkgconfig
"
