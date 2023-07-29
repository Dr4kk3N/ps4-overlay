# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PVCUT=$(ver_cut 1-2)
QTMIN=6.0
inherit ecm frameworks.kde.org

DESCRIPTION="Classes to read and interact with KColorScheme"

LICENSE="LGPL-2+"
KEYWORDS=""
IUSE="+man"

RDEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[dbus,gui,widgets]
	>=kde-frameworks/ki18n-${PVCUT}:6
"
DEPEND="${RDEPEND}
	test? ( =kde-frameworks/kconfig-${PVCUT}*:6[dbus] )
"
BDEPEND="man? ( >=kde-frameworks/kdoctools-${PVCUT}:6 )"

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package man KF6DocTools)
	)

	ecm_src_configure
}
