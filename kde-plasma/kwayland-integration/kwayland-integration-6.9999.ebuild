# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KFMIN=6.0
QTMIN=6.0
inherit ecm plasma.kde.org

DESCRIPTION="Provides KWindowSystem integration plugin for Wayland"
HOMEPAGE="https://invent.kde.org/plasma/kwayland-integration"

LICENSE="LGPL-2.1"
SLOT="5"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc64 ~riscv ~x86"
IUSE=""

# dev-qt/qtgui: QtXkbCommonSupport is provided by either IUSE libinput or X
# slot ops:
# dev-qt/qtgui: QtXkbCommonSupportPrivate
# dev-qt/qtwayland: Qt::WaylandClientPrivate (private/qwayland*_p.h) stuff
# kde-frameworks/kwindowsystem: Various private headers
DEPEND="
	>=dev-libs/wayland-1.15
	>=dev-qt/qtbase-${QTMIN}:6=
	|| (
		>=dev-qt/qtbase-${QTMIN}:6[libinput]
		>=dev-qt/qtbase-${QTMIN}:6[X]
		>=dev-qt/qtbase-${QTMIN}:6[widgets]
	)
	>=dev-qt/qtwayland-${QTMIN}:6=
	>=kde-frameworks/kwayland-${KFMIN}:6
	>=kde-frameworks/kwindowsystem-${KFMIN}:6=
	x11-libs/libxkbcommon
"
RDEPEND="${DEPEND}"
BDEPEND="
	>=dev-qt/qtwaylandscanner-${QTMIN}:6
	dev-util/wayland-scanner
	virtual/pkgconfig
"

src_prepare() {
	ecm_src_prepare
	ecm_punt_kf_module IdleTime
	cmake_comment_add_subdirectory autotests # only contains idletime test
	cmake_run_in src cmake_comment_add_subdirectory idletime
}
