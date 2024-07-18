# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

WX_GTK_VER="3.2-gtk3"

inherit cmake xdg wxwidgets git-r3

DESCRIPTION="powerful open-source, cross platform IDE for the C/C++"
HOMEPAGE="http://www.codelite.org"

EGIT_REPO_URI="https://github.com/eranif/codelite.git"

SRC_URI=""

LICENSE="GPL-2"
SLOT="0"

KEYWORDS=""

CMAKE_BUILD_TYPE="Release"

RDEPEND=">=x11-libs/wxGTK-3.2.2.1-r3:3.2-gtk3
	>=dev-cpp/yaml-cpp-0.8.0
	dev-vcs/git
	net-libs/libssh"
DEPEND="${RDEPEND}"
BDEPEND=">=dev-build/cmake-3.16"

src_prepare() {
	setup-wxwidgets
	cmake_src_prepare
	eapply_user
}

src_configure() {
	cmake_src_configure
}

pkg_postinst() {
	xdg_pkg_postinst
}

pkg_postrm() {
	xdg_pkg_postrm
}
