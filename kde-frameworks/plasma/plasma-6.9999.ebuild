# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KDE_ORG_NAME="${PN}-framework"
PVCUT=$(ver_cut 1-2)
QTMIN=6.4.2
inherit ecm frameworks.kde.org

DESCRIPTION="Plasma framework"

LICENSE="LGPL-2+"
KEYWORDS=""
IUSE="gles2-only man wayland"

RESTRICT="test"

# kde-frameworks/kwindowsystem[X]: Unconditional use of KX11Extras
RDEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[dbus,gui,widgets,sql,gles2-only=,X]
	>=dev-qt/qtdeclarative-${QTMIN}:6
	>=dev-qt/qtsvg-${QTMIN}:6
	=kde-frameworks/kactivities-${PVCUT}*:6
	=kde-frameworks/karchive-${PVCUT}*:6
	=kde-frameworks/kconfig-${PVCUT}*:6[qml]
	=kde-frameworks/kconfigwidgets-${PVCUT}*:6
	=kde-frameworks/kcoreaddons-${PVCUT}*:6
	=kde-frameworks/kdeclarative-${PVCUT}*:6
	=kde-frameworks/kglobalaccel-${PVCUT}*:6
	=kde-frameworks/kguiaddons-${PVCUT}*:6
	=kde-frameworks/ki18n-${PVCUT}*:6
	=kde-frameworks/kiconthemes-${PVCUT}*:6
	=kde-frameworks/kio-${PVCUT}*:6
	=kde-frameworks/kirigami-${PVCUT}*:6
	=kde-frameworks/knotifications-${PVCUT}*:6
	=kde-frameworks/kpackage-${PVCUT}*:6
	=kde-frameworks/kservice-${PVCUT}*:6
	=kde-frameworks/kwidgetsaddons-${PVCUT}*:6
	=kde-frameworks/kwindowsystem-${PVCUT}*:6[X]
	=kde-frameworks/kxmlgui-${PVCUT}*:6
	x11-libs/libX11
	x11-libs/libxcb
	!gles2-only? ( media-libs/libglvnd[X] )
	wayland? (
		=kde-frameworks/kwayland-${PVCUT}*:6
		media-libs/libglvnd
	)
"
DEPEND="${RDEPEND}
	x11-base/xorg-proto
"
BDEPEND="man? ( >=kde-frameworks/kdoctools-${PVCUT}:6 )"

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package !gles2-only OpenGL)
		$(cmake_use_find_package man KF6DocTools)
		$(cmake_use_find_package wayland EGL)
		$(cmake_use_find_package wayland KF6Wayland)
	)

	ecm_src_configure
}
