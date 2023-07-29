# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PVCUT=$(ver_cut 1-2)
QTMIN=6.4.0
inherit ecm frameworks.kde.org

DESCRIPTION="Framework to install and load packages of non binary content"

LICENSE="LGPL-2+"
KEYWORDS=""
IUSE="man"

BDEPEND="
	man? ( >=kde-frameworks/kdoctools-${PVCUT}:6 )
"
DEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[dbus]
	=kde-frameworks/karchive-${PVCUT}*:6
	=kde-frameworks/kcoreaddons-${PVCUT}*:6
	=kde-frameworks/ki18n-${PVCUT}*:6
"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package man KF6DocTools)
	)

	ecm_src_configure
}

src_test() {
	# plasma-plasmoidpackagetest bug 650214
	# testpackage-appstream requires network access
	local myctestargs=( -E "(plasma-plasmoidpackagetest|testpackage-appstream)" )
	ecm_src_test
}
