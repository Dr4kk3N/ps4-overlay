# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PVCUT=$(ver_cut 1-2)
PLASMA_MINIMAL=6.0
QTMIN=6.4.2
inherit ecm frameworks.kde.org

DESCRIPTION="Framework for working with KDE activities"
LICENSE="|| ( LGPL-2.1 LGPL-3 )"
KEYWORDS=""
IUSE=""

COMMON_DEPEND="
	>=dev-qt/qtdeclarative-${QTMIN}:6[widgets]
	=kde-frameworks/kconfig-${PVCUT}*:6
	=kde-frameworks/kcoreaddons-${PVCUT}*:6
"
RDEPEND="${COMMON_DEPEND}
"
DEPEND="${COMMON_DEPEND}
	dev-libs/boost
"
