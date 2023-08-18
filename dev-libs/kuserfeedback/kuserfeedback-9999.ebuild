# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_TEST="forceoptional"
KFMIN=5.240.0
QTMIN=6.4.2
inherit ecm kde.org

DESCRIPTION="Framework to collect user feedback for applications via telemetry and surveys"

if [[ ${KDE_BUILD_TYPE} = release ]]; then
	SRC_URI="mirror://kde/stable/${PN}/${P}.tar.xz"
	KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~riscv ~x86"
fi
LICENSE="MIT"
SLOT="6"
IUSE="-doc"

BDEPEND="
	sys-devel/bison
	sys-devel/flex
"
DEPEND="
	>=dev-qt/qtcharts-${QTMIN}:6
	>=dev-qt/qtdeclarative-${QTMIN}:6
	>=dev-qt/qtbase-${QTMIN}:6[gui,network,cups,sql,widgets]
	>=dev-qt/qtsvg-${QTMIN}:6
	>=kde-frameworks/kconfig-${KFMIN}:6
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	>=kde-frameworks/kdeclarative-${KFMIN}:6
	>=kde-frameworks/kguiaddons-${KFMIN}:6
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:6
"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		# disable server application
		-DENABLE_PHP=NO
		-DENABLE_PHP_UNIT=NO
		-DENABLE_SURVEY_TARGET_EXPRESSIONS=YES
		-DENABLE_DOCS=$(usex doc)
		-DKUSERFEEDBACK_EXTENSION=Qt6
	)

	ecm_src_configure
}
