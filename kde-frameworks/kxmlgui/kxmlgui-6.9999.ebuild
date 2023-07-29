# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_DESIGNERPLUGIN="true"
PVCUT=$(ver_cut 1-2)
QTMIN=6.0
inherit ecm frameworks.kde.org

DESCRIPTION="Framework for managing menu and toolbar actions in an abstract way"

KEYWORDS=""
LICENSE="LGPL-2+"
IUSE="doc"

# slot op: includes QtCore/private/qlocale_p.h
DEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[dbus,gui,network,ssl,cups,widgets,xml]
	=kde-frameworks/kconfig-${PVCUT}*:6
	=kde-frameworks/kconfigwidgets-${PVCUT}*:6
	=kde-frameworks/kcoreaddons-${PVCUT}*:6
	=kde-frameworks/kglobalaccel-${PVCUT}*:6
	=kde-frameworks/kguiaddons-${PVCUT}*:6
	=kde-frameworks/ki18n-${PVCUT}*:6
	=kde-frameworks/kiconthemes-${PVCUT}*:6
	=kde-frameworks/kitemviews-${PVCUT}*:6
	=kde-frameworks/kwidgetsaddons-${PVCUT}*:6
	doc? ( >=dev-qt/qtdoc-${PVCUT}:6 )
"
RDEPEND="${DEPEND}"

src_test() {
	# Files are missing; whatever. Bugs 650290, 668198, 808216
	local myctestargs=(
		-E "(ktoolbar_unittest|kxmlgui_unittest|ktooltiphelper_unittest)"
	)

	ecm_src_test
}
