# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_QTHELP="true"
ECM_TEST="forceoptional"
KFMIN=5.240.0
PVCUT=$(ver_cut 1-3)
QTMIN=6.4.2
inherit ecm plasma.kde.org

DESCRIPTION="Plasma screen management library"

LICENSE="GPL-2" # TODO: CHECK
SLOT="6/8"
KEYWORDS=""
IUSE=""

# requires running session
RESTRICT="test"

RDEPEND="
	dev-libs/wayland
	>=dev-qt/qtbase-${QTMIN}:6[X,dbus,gui]
	>=kde-frameworks/kconfig-${KFMIN}:6
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	>=kde-plasma/kwayland-${KFMIN}:6
	x11-libs/libxcb
"
DEPEND="${RDEPEND}
	>=dev-libs/plasma-wayland-protocols-1.10.0
"
BDEPEND="
	>=dev-qt/qttools-${QTMIN}:6
	dev-util/wayland-scanner
"
