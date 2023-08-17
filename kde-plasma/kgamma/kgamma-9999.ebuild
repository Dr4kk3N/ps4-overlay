# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_HANDBOOK="forceoptional"
KDE_ORG_NAME="${PN}5"
KFMIN=5.240.0
PVCUT=$(ver_cut 1-3)
QTMIN=6.4.2
inherit ecm plasma.kde.org

DESCRIPTION="Screen gamma values kcontrol module"

LICENSE="GPL-2" # TODO: CHECK
SLOT="6"
KEYWORDS=""
IUSE=""

RDEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[gui,widgets]
	>=kde-frameworks/kconfig-${KFMIN}:6
	>=kde-frameworks/kconfigwidgets-${KFMIN}:6
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
	x11-libs/libX11
	x11-libs/libXxf86vm
"
DEPEND="${RDEPEND}
	x11-base/xorg-proto
"
