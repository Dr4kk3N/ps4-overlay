# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_DESIGNERPLUGIN="true"
QTMIN=6.4.2
inherit ecm frameworks.kde.org

DESCRIPTION="Framework for providing spell-checking through abstraction of popular backends"

LICENSE="LGPL-2+ LGPL-2.1+"
KEYWORDS=""
IUSE="aspell +hunspell qml"

DEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[gui,widgets]
	aspell? ( app-text/aspell )
	hunspell? ( app-text/hunspell:= )
	qml? ( >=dev-qt/qtdeclarative-${QTMIN}:6 )
"
RDEPEND="${DEPEND}"
BDEPEND=">=dev-qt/qttools-${QTMIN}:6"

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package aspell ASPELL)
		$(cmake_use_find_package hunspell HUNSPELL)
		-DSONNET_USE_QML=$(usex qml)
	)

	ecm_src_configure
}

src_test() {
	# sonnet-test_settings: bug 680032
	# sonnet-test_autodetect: bug 779994
	local myctestargs=(
		-E "(sonnet-test_autodetect|sonnet-test_settings|sonnet-test_highlighter)"
	)

	ecm_src_test
}
