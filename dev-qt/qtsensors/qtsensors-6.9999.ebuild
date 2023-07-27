# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit qt6-build

DESCRIPTION="Hardware sensor access library for the Qt5 framework"

if [[ ${QT6_BUILD_TYPE} == release ]]; then
	KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86"
fi

# TODO: simulator
IUSE="qml"

RDEPEND="
	=dev-qt/qtbase-${PV}*
	qml? ( =dev-qt/qtdeclarative-${PV}* )
"
DEPEND="${RDEPEND}"

src_prepare() {
	qt_use_disable_mod qml quick \
		src/src.pro

	qt6-build_src_prepare
}
