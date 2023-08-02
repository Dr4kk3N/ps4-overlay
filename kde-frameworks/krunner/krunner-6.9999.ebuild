# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PVCUT=$(ver_cut 1-2)
QTMIN=6.4.2
inherit ecm frameworks.kde.org

DESCRIPTION="Framework for providing different actions given a string query"

LICENSE="LGPL-2+"
KEYWORDS=""
IUSE="activities"

DEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[dbus,gui,widgets]
	>=dev-qt/qtdeclarative-${QTMIN}:6
	=kde-frameworks/kconfig-${PVCUT}*:6
	=kde-frameworks/kcoreaddons-${PVCUT}*:6
	=kde-frameworks/ki18n-${PVCUT}*:6
	=kde-frameworks/kio-${PVCUT}*:6
	=kde-frameworks/kservice-${PVCUT}*:6
	=kde-frameworks/plasma-${PVCUT}*:6
	=kde-frameworks/solid-${PVCUT}*:6
	=kde-frameworks/threadweaver-${PVCUT}*:6
	activities? ( =kde-frameworks/kactivities-${PVCUT}*:6 )
"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package activities KF5Activities)
	)
	ecm_src_configure
}

src_test() {
	# requires virtual dbus, otherwise hangs; bugs #630672, #789351, #838502
	local myctestargs=(
		-E "(dbusrunnertest|runnermanagersinglerunnermodetest|runnermanagertest)"
	)
	ecm_src_test
}
