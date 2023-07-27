# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

if [[ ${PV} != *9999* ]]; then
	KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~riscv ~x86"
fi

QT6_MODULE="qttools"
inherit qt6-build

DESCRIPTION="Qt documentation generator"

IUSE="qml"

DEPEND="
	=dev-qt/qtbase-${PV}*:5=
	sys-devel/clang:=
	qml? ( =dev-qt/qtdeclarative-${PV}* )
"
RDEPEND="${DEPEND}"

QT5_TARGET_SUBDIRS=(
	src/qdoc
)

src_prepare() {
	qt_use_disable_mod qml qmldevtools-private \
		src/qdoc/qdoc.pro

	qt5-build_src_prepare
}

src_configure() {
	# qt6_tools_configure() not enough here, needs another fix, bug 676948
	qt6_configure_oos_quirk qtqdoc-config.pri src/qdoc
	qt6-build_src_configure
}
