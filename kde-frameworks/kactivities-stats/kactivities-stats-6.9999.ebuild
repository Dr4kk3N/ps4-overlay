# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PVCUT=$(ver_cut 1-2)
QTMIN=6.4.2
inherit ecm frameworks.kde.org

DESCRIPTION="Framework for getting the usage statistics collected by the activities service"
LICENSE="LGPL-2+"
KEYWORDS=""
IUSE=""

RDEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[dbus,sql]
	=kde-frameworks/kactivities-${PVCUT}*:6
	=kde-frameworks/kconfig-${PVCUT}*:6
"
DEPEND="${RDEPEND}
	test? ( dev-libs/boost )
"
