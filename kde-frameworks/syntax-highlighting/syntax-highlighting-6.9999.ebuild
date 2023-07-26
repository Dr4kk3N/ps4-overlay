# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_TEST="forceoptional"
QTMIN=6.0
inherit ecm frameworks.kde.org

DESCRIPTION="Framework for syntax highlighting"

LICENSE="MIT"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc64 ~riscv ~x86"
IUSE=""

DEPEND="
	>=dev-qt/qtbase-${QTMIN}:6
	>=dev-qt/qtdeclarative-${QTMIN}:6
	"
RDEPEND="${DEPEND}"
BDEPEND="
	dev-lang/perl
	>=dev-qt/qttools-${QTMIN}:6[linguist]
"

src_install() {
	ecm_src_install
	dobin "${BUILD_DIR}"/bin/katehighlightingindexer
}
