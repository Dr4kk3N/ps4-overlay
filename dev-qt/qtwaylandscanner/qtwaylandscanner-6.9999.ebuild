# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

QT6_MODULE="qtwayland"
inherit qt6-build

DESCRIPTION="Tool that generates certain boilerplate C++ code from Wayland protocol xml spec"

if [[ ${QT5_BUILD_TYPE} == release ]]; then
	KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86"
fi

DEPEND="dev-qt/qtbase:6[gui,opengl]"
RDEPEND="${DEPEND}
	!<dev-qt/qtwayland-6.9999:6
"

QT5_TARGET_SUBDIRS=(
	src/qtwaylandscanner
)
