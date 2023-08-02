# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_HANDBOOK="true"
ECM_QTHELP="false"
PVCUT=$(ver_cut 1-2)
QTMIN=6.4.2
inherit ecm frameworks.kde.org

DESCRIPTION="Framework easing the development transition from KDELibs 4 to KF 5"

LICENSE="LGPL-2+"
KEYWORDS=""
IUSE="X"

RESTRICT="test"

COMMON_DEPEND="
	app-text/docbook-xml-dtd:4.2
	dev-libs/openssl:0
	>=dev-qt/qtbase-${QTMIN}:6[dbus,gui,network,ssl,cups,widgets]
	>=dev-qt/qtsvg-${QTMIN}:6
	>=dev-qt/qttest-${QTMIN}:6
	=kde-frameworks/kauth-${PVCUT}*:6
	=kde-frameworks/kcodecs-${PVCUT}*:6
	=kde-frameworks/kcompletion-${PVCUT}*:6
	=kde-frameworks/kconfig-${PVCUT}*:6
	=kde-frameworks/kconfigwidgets-${PVCUT}*:6
	=kde-frameworks/kcoreaddons-${PVCUT}*:6
	=kde-frameworks/kcrash-${PVCUT}*:6
	=kde-frameworks/kdbusaddons-${PVCUT}*:6
	>=kde-frameworks/kded-${PVCUT}:6
	=kde-frameworks/kdoctools-${PVCUT}*:6
	=kde-frameworks/kemoticons-${PVCUT}*:6
	=kde-frameworks/kglobalaccel-${PVCUT}*:6
	=kde-frameworks/kguiaddons-${PVCUT}*:6
	=kde-frameworks/ki18n-${PVCUT}*:6
	=kde-frameworks/kiconthemes-${PVCUT}*:6
	=kde-frameworks/kio-${PVCUT}*:6
	=kde-frameworks/kitemviews-${PVCUT}*:6
	=kde-frameworks/kjobwidgets-${PVCUT}*:6
	=kde-frameworks/knotifications-${PVCUT}*:6[X?]
	=kde-frameworks/kparts-${PVCUT}*:6
	=kde-frameworks/kservice-${PVCUT}*:6
	=kde-frameworks/ktextwidgets-${PVCUT}*:6
	=kde-frameworks/kunitconversion-${PVCUT}*:6
	=kde-frameworks/kwidgetsaddons-${PVCUT}*:6
	=kde-frameworks/kwindowsystem-${PVCUT}*:6[X?]
	=kde-frameworks/kxmlgui-${PVCUT}*:6
	=kde-frameworks/solid-${PVCUT}*:6
	virtual/libintl
	X? (
		x11-libs/libICE
		x11-libs/libSM
		x11-libs/libX11
		x11-libs/libxcb
	)
"
DEPEND="${COMMON_DEPEND}
	test? ( >=dev-qt/qtbase-${QTMIN}:6[concurrent] )
	X? ( x11-base/xorg-proto )
"
RDEPEND="${COMMON_DEPEND}
	>=dev-qt/qtxml-${QTMIN}:6
	>=kde-frameworks/countryflags-${PVCUT}:6
	=kde-frameworks/kinit-${PVCUT}*:6
	=kde-frameworks/kitemmodels-${PVCUT}*:6
"
BDEPEND="
	dev-lang/perl
	dev-perl/URI
"

PATCHES=(
	# downstream patches
	"${FILESDIR}/${PN}-5.80.0-no-kdesignerplugin.patch" # bug 755956
	"${FILESDIR}/${PN}-5.86.0-unused-dep.patch" # bug 755956
)

src_prepare() {
	ecm_src_prepare

	if ! use handbook; then
		sed -e "/kdoctools_install/ s/^/#DONT/" -i CMakeLists.txt || die
	fi

	cmake_run_in src cmake_comment_add_subdirectory l10n
}

src_configure() {
	local mycmakeargs=(
		-DWITH_X11=$(usex X)
	)

	ecm_src_configure
}
