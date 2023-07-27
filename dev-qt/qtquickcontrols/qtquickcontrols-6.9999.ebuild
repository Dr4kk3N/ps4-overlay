# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit qt6-build

DESCRIPTION="Set of Qt Quick controls to create complete user interfaces (deprecated)"

if [[ ${QT6_BUILD_TYPE} == release ]]; then
	KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~loong ~ppc ~ppc64 ~riscv ~x86"
fi

IUSE="+widgets"

DEPEND="
	=dev-qt/qtbase-${PV}*
	=dev-qt/qtdeclarative-${PV}*
	=dev-qt/qtbase-${PV}[gui]
	widgets? ( =dev-qt/qtbase-${PV}[widgets] )
"
RDEPEND="${DEPEND}"

src_prepare() {
	qt_use_disable_mod widgets widgets \
		src/src.pro \
		src/controls/Private/private.pri \
		tests/auto/activeFocusOnTab/activeFocusOnTab.pro \
		tests/auto/controls/controls.pro \
		tests/auto/testplugin/testplugin.pro

	qt6-build_src_prepare
}
