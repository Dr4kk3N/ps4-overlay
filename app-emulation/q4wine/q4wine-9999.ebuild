# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Upstream names the package PV-rX. We change that to
# PV_pX so we can use portage revisions.
MY_P=${PN}-${PV/_p/-r}
inherit cmake git-r3 xdg

DESCRIPTION="Qt GUI configuration tool for Wine"
HOMEPAGE="https://q4wine.brezblock.org.ua/"
EGIT_REPO_URI="https://github.com/brezerk/q4wine.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="+dbus debug +ico +iso +wineappdb"

DEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtsingleapplication[qt5(+),X]
	dev-qt/qtsql:5[sqlite]
	dev-qt/qtsvg:5
	dev-qt/qtwidgets:5
	dev-qt/qtxml:5
	dbus? ( dev-qt/qtdbus:5 )
	ico? ( >=media-gfx/icoutils-0.26.0 )
"
RDEPEND="${DEPEND}
	app-admin/sudo
	>=sys-apps/which-2.19
	iso? ( sys-fs/fuseiso )
"
BDEPEND="
	dev-qt/linguist-tools:5
"

S="${WORKDIR}"/${MY_P}

DOCS=( AUTHORS ChangeLog README )

src_configure() {
	local mycmakeargs=(
		-DDEBUG=$(usex debug ON OFF)
		-DWITH_ICOUTILS=$(usex ico ON OFF)
		-DWITH_SYSTEM_SINGLEAPP=ON
		-DWITH_WINEAPPDB=$(usex wineappdb ON OFF)
		-DUSE_BZIP2=OFF
		-DUSE_GZIP=OFF
		-DWITH_DBUS=$(usex dbus ON OFF)
	)
	cmake_src_configure
}
