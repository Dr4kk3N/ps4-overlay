# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PVCUT=$(ver_cut 1-2)
QTMIN=6.0
inherit ecm frameworks.kde.org

DESCRIPTION="Framework to handle global shortcuts"

LICENSE="LGPL-2+"
KEYWORDS=""
IUSE="X"

REQUIRED_USE="test? ( X )"
RESTRICT="test" # requires installed instance

RDEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[X,dbus,gui,widgets]
	X? (
		=kde-frameworks/kconfig-${PVCUT}*:6
		=kde-frameworks/kcoreaddons-${PVCUT}*:6
		=kde-frameworks/kcrash-${PVCUT}*:6
		=kde-frameworks/kdbusaddons-${PVCUT}*:6
		=kde-frameworks/kwindowsystem-${PVCUT}*:6[X]
		x11-libs/libxcb
		x11-libs/xcb-util-keysyms
	)
"
DEPEND="${RDEPEND}
	test? (
		>=dev-qt/qtdeclarative-${QTMIN}:6
		=kde-frameworks/kdeclarative-${PVCUT}*:6
	)
"
BDEPEND=">=dev-qt/qttools-${QTMIN}:6[linguist]"

src_configure() {
	local mycmakeargs=(
		-DBUILD_RUNTIME=$(usex X)
	)
	ecm_src_configure
}

src_test() {
	XDG_CURRENT_DESKTOP="KDE" ecm_src_test # bug 789342
}
