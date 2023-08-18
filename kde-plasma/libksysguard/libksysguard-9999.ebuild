# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_DESIGNERPLUGIN="true"
ECM_TEST="true"
KFMIN=5.240.0
QTMIN=6.4.2
inherit ecm plasma.kde.org

DESCRIPTION="Task management and system monitoring library"

LICENSE="LGPL-2+"
SLOT="6/9"
KEYWORDS=""
IUSE="webengine"

COMMON_DEPEND="
	dev-libs/libnl:3
	>=dev-qt/qtbase-${QTMIN}:6[X,dbus,gui,network,widgets]
	>=dev-qt/qtdeclarative-${QTMIN}:6
	>=kde-frameworks/kauth-${KFMIN}:6
	>=kde-frameworks/kcompletion-${KFMIN}:6
	>=kde-frameworks/kconfig-${KFMIN}:6[qml]
	>=kde-frameworks/kconfigwidgets-${KFMIN}:6
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
	>=kde-frameworks/kjobwidgets-${KFMIN}:6
	>=kde-frameworks/knewstuff-${KFMIN}:6
	>=kde-frameworks/kpackage-${KFMIN}:6
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:6
	>=kde-frameworks/kwindowsystem-${KFMIN}:6[X]
	net-libs/libpcap
	sys-apps/lm-sensors:=
	sys-libs/libcap
	sys-libs/zlib
	x11-libs/libX11
	x11-libs/libXres
	webengine? (
		>=dev-qt/qtwebchannel-${QTMIN}:6
		>=dev-qt/qtwebengine-${QTMIN}:6
	)
"
DEPEND="${COMMON_DEPEND}
	>=kde-frameworks/kiconthemes-${KFMIN}:6
	x11-base/xorg-proto
"
RDEPEND="${COMMON_DEPEND}
	!<kde-plasma/ksysguard-5.21.90:5
"

# downstream patch
PATCHES=( "${FILESDIR}/${PN}-5.22.80-no-detailed-mem-message.patch" )

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package webengine Qt6WebChannel)
		$(cmake_use_find_package webengine Qt6WebEngineWidgets)
	)

	ecm_src_configure
}

src_test() {
	# bugs 797898, 889942: flaky test
	local myctestargs=(
		-E "(sensortreemodeltest)"
	)
	LC_NUMERIC="C" ecm_src_test # bug 695514
}
