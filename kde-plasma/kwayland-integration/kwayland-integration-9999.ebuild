# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KFMIN=9999
QTMIN=6.6.0
inherit ecm flag-o-matic plasma.kde.org

DESCRIPTION="Provides KWindowSystem integration plugin for Wayland"
HOMEPAGE="https://invent.kde.org/plasma/kwayland-integration"

LICENSE="LGPL-2.1"
SLOT="6"
KEYWORDS=""
IUSE=""

RDEPEND="
	>=dev-libs/wayland-1.15
	>=dev-qt/qtgui-${QTMIN}:6[X,widgets,libinput]
	>=dev-qt/qtwayland-${QTMIN}:6=
	>=kde-frameworks/kwindowsystem-${KFMIN}:6=
	>=kde-plasma/kwayland-${KFMIN}:6
	x11-libs/libxkbcommon
"
DEPEND="${RDEPEND}
	dev-libs/plasma-wayland-protocols
"
BDEPEND="
	>=dev-qt/qtwaylandscanner-${QTMIN}:6
	dev-util/wayland-scanner
	virtual/pkgconfig
"

src_configure() {
	filter-lto # bug 921430
	ecm_src_configure
}
