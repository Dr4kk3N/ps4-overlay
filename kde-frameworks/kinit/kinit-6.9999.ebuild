# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_QTHELP="false"
ECM_TEST="false"
PVCUT=$(ver_cut 1-2)
QTMIN=6.4.0
inherit ecm frameworks.kde.org

DESCRIPTION="Helper library to speed up start of applications on KDE workspaces"

LICENSE="LGPL-2+"
KEYWORDS=""
IUSE="+caps +man X"

RDEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[dbus,gui]
	=kde-frameworks/kconfig-${PVCUT}*:6
	=kde-frameworks/kcoreaddons-${PVCUT}*:6
	=kde-frameworks/kcrash-${PVCUT}*:6
	=kde-frameworks/kdbusaddons-${PVCUT}*:6
	=kde-frameworks/ki18n-${PVCUT}*:6
	=kde-frameworks/kio-${PVCUT}*:6
	=kde-frameworks/kservice-${PVCUT}*:6
	=kde-frameworks/kwindowsystem-${PVCUT}*:6[X?]
	caps? ( sys-libs/libcap )
	X? (
		x11-libs/libX11
		x11-libs/libxcb
	)
"
DEPEND="${RDEPEND}
	X? ( x11-base/xorg-proto )
"
BDEPEND="man? ( >=kde-frameworks/kdoctools-${PVCUT}:6 )"

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package caps Libcap)
		$(cmake_use_find_package man KF6DocTools)
		-DWITH_X11=$(usex X)
	)

	ecm_src_configure
}
