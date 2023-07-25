# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit virtualx xdg-utils cmake git-r3

DESCRIPTION="Neovim client library and GUI, in Qt5"
HOMEPAGE="https://github.com/equalsraf/neovim-qt"
EGIT_REPO_URI="https://github.com/equalsraf/neovim-qt.git"

LICENSE="ISC"
SLOT="0"
KEYWORDS=""
IUSE="test gcov +msgpack +clipboard"

COMMON_DEPEND="
	msgpack? ( dev-libs/msgpack )
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtsvg:5
	dev-qt/qtwidgets:5
	"
# NOTE: remove dejavu once <https://github.com/equalsraf/neovim-qt/issues/1005>
#       is resolved

DEPEND="
	${COMMON_DEPEND}
	test? ( dev-qt/qttest:5
		media-fonts/dejavu[X]
	)
	"

RDEPEND="
	${COMMON_DEPEND}
	app-editors/neovim
	clipboard? ( x11-misc/xclip )
	clipboard? ( x11-misc/xsel )
	"

RESTRICT="!test? ( test )"

PATCHES=(
	"${FILESDIR}"/${P}-only-require-Qt5Test-if-tests-are-enabled.patch
	"${FILESDIR}"/${P}-fix-finding-msgpack-6+.patch
)

src_configure() {
	CMAKE_BUILD_TYPE="Release"

	local mycmakeargs=(
		-DUSE_GCOV=$(usex gcov ON OFF)
		-DUSE_SYSTEM_MSGPACK=$(usex msgpack ON OFF)
		-DENABLE_TESTS=$(usex test)
		-DBUILD_SHARED_LIBS=OFF # upstream explicitly builds static lib
	)
	cmake_src_configure
}

src_test() {
	virtx cmake_src_test
}

pkg_postinst() {
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
}
