# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_QTHELP="false"
PVCUT=$(ver_cut 1-2)
QTMIN=6.4.2
inherit ecm frameworks.kde.org

DESCRIPTION="KHTML web rendering engine"
LICENSE="LGPL-2"
KEYWORDS=""
IUSE="X"

RDEPEND="
	dev-libs/openssl:0
	>=dev-qt/qtbase-${QTMIN}:6[dbus,gui,network,cups,widgets,xml]
	=kde-frameworks/karchive-${PVCUT}*:6
	=kde-frameworks/kcodecs-${PVCUT}*:6
	=kde-frameworks/kcompletion-${PVCUT}*:6
	=kde-frameworks/kconfig-${PVCUT}*:6
	=kde-frameworks/kconfigwidgets-${PVCUT}*:6
	=kde-frameworks/kcoreaddons-${PVCUT}*:6
	=kde-frameworks/kglobalaccel-${PVCUT}*:6
	=kde-frameworks/ki18n-${PVCUT}*:6
	=kde-frameworks/kiconthemes-${PVCUT}*:6
	=kde-frameworks/kio-${PVCUT}*:6
	=kde-frameworks/kjobwidgets-${PVCUT}*:6
	=kde-frameworks/kjs-${PVCUT}*:6
	=kde-frameworks/knotifications-${PVCUT}*:6
	=kde-frameworks/kparts-${PVCUT}*:6
	=kde-frameworks/kservice-${PVCUT}*:6
	=kde-frameworks/ktextwidgets-${PVCUT}*:6
	=kde-frameworks/kwallet-${PVCUT}*:6
	=kde-frameworks/kwidgetsaddons-${PVCUT}*:6
	=kde-frameworks/kwindowsystem-${PVCUT}*:6[X?]
	=kde-frameworks/kxmlgui-${PVCUT}*:6
	=kde-frameworks/sonnet-${PVCUT}*:6
	media-libs/giflib:=
	media-libs/libjpeg-turbo:=
	media-libs/libpng:0=
	>=media-libs/phonon-4.11.0
	sys-libs/zlib
	X? (
		x11-libs/libX11
	)
"
DEPEND="${RDEPEND}
	X? ( x11-base/xorg-proto )
"
BDEPEND="
	dev-lang/perl
	dev-util/gperf
"

src_configure() {
	local mycmakeargs=(
		-DWITH_X11=$(usex X)
	)

	ecm_src_configure
}
