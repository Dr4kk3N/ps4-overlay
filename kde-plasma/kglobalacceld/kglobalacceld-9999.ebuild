# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PVCUT=$(ver_cut 1-2)
QTMIN=6.4.2
inherit ecm plasma.kde.org

DESCRIPTION="Daemon providing Global Keyboard Shortcut (Accelerator) functionality"

LICENSE="LGPL-2+"
SLOT="6"
KEYWORDS=""
IUSE="X"

REQUIRED_USE="X"

RDEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[X,dbus,gui,widgets]
	X? (
		=kde-frameworks/kconfig-6.${PVCUT}*:6
		=kde-frameworks/kcoreaddons-6.${PVCUT}*:6
		=kde-frameworks/kcrash-6.${PVCUT}*:6
		=kde-frameworks/kdbusaddons-6.${PVCUT}*:6
		=kde-frameworks/kwindowsystem-6.${PVCUT}*:6[X]
		x11-libs/libxcb
		x11-libs/xcb-util-keysyms
		>=dev-qt/qtdeclarative-${QTMIN}:6
                =kde-frameworks/kdeclarative-6.${PVCUT}*:6
	)
"
DEPEND=${RDEPEND}
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
