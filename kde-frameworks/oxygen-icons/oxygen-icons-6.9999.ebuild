# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KDE_ORG_NAME="oxygen-icons5"
PVCUT=$(ver_cut 1-2)
QTMIN=6.4.2
inherit cmake frameworks.kde.org xdg-utils

DESCRIPTION="Oxygen SVG icon theme"

LICENSE="LGPL-3"
KEYWORDS=""
IUSE="test"

RESTRICT="!test? ( test )"

BDEPEND="
	>=dev-qt/qtbase-${QTMIN}:6
	>=kde-frameworks/extra-cmake-modules-${PVCUT}:6
	test? ( app-misc/fdupes )
"
DEPEND="test? ( >=dev-qt/qttest-${QTMIN}:6 )"

src_prepare() {
	cmake_src_prepare
	use test || cmake_comment_add_subdirectory autotests
}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
