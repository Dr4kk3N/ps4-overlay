# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_NONGUI="false"
QTMIN=6.0
inherit ecm frameworks.kde.org

DESCRIPTION="Framework providing assorted high-level user interface components"

LICENSE="LGPL-2+"
KEYWORDS=""
IUSE="dbus wayland X"

# slot op: includes qpa/qplatformnativeinterface.h
RDEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[gui]
	dbus? ( >=dev-qt/qtbase-${QTMIN}:6[dbus] )
	wayland? (
		dev-libs/wayland
		>=dev-qt/qtbase-${QTMIN}:6=[wayland]
		>=dev-qt/qtwayland-${QTMIN}:6
	)
	X? (
		x11-libs/libX11
	)
"
DEPEND="${RDEPEND}
	x11-base/xorg-proto
	wayland? ( >=dev-libs/plasma-wayland-protocols-1.7.0 )
	X? ( x11-libs/libxcb )
"

src_configure() {
	local mycmakeargs=(
		-DBUILD_GEO_SCHEME_HANDLER=ON # coordinate on/off with KF6
		-DWITH_DBUS=$(usex dbus)
		-DWITH_WAYLAND=$(usex wayland)
		-DWITH_X11=$(usex X)
	)
	ecm_src_configure
}
