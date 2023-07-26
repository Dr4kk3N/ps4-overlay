# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

QTMIN=6.0
inherit ecm frameworks.kde.org

DESCRIPTION="Framework providing access to properties and features of the window manager"

LICENSE="|| ( LGPL-2.1 LGPL-3 ) MIT"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc64 ~riscv ~x86"
IUSE="wayland X"

RESTRICT="test"

RDEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[gui]
	X? (
		x11-libs/libX11
		x11-libs/libXfixes
		x11-libs/libxcb
		x11-libs/xcb-util-keysyms
	)
"
DEPEND="${RDEPEND}
	X? ( x11-base/xorg-proto )
	test? ( >=dev-qt/qtwidgets-${QTMIN}:6 )
"
BDEPEND=">=dev-qt/qttools-${QTMIN}:6[linguist]"
PDEPEND="wayland? ( >=kde-plasma/kwayland-integration-6.0:6 )"

DOCS=( docs/README.kstartupinfo )

src_configure() {
	local mycmakeargs=(
		-DKWINDOWSYSTEM_NO_WIDGETS=ON
		$(cmake_use_find_package X X11)
	)

	ecm_src_configure
}
