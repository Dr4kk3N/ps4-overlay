# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit qmake-utils xdg

QTW_PN="qmltermwidget"

DESCRIPTION="A good looking terminal emulator which mimics the old cathode display"
HOMEPAGE="https://github.com/Swordfish90/cool-retro-term"

if [[ ${PV} == *9999* ]];then
	inherit git-r3
	KEYWORDS=""
	EGIT_REPO_URI="${HOMEPAGE}"
else
	SRC_URI="${HOMEPAGE}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~x86 ~amd64"
	RESTRICT="mirror"
fi

LICENSE="GPL-3 GPL-2"
SLOT="0"
IUSE=""

DEPEND="
	dev-qt/qtcore:5
	dev-qt/qtdeclarative:5[localstorage]
	dev-qt/qtgraphicaleffects:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtquickcontrols:5[widgets]
	dev-qt/qtquickcontrols2:5[widgets]
	dev-qt/qtwidgets:5
"

RDEPEND="${DEPEND}
	virtual/opengl"

src_prepare() {
	default

#	rmdir "${QTW_PN}" || die
#	mv "${WORKDIR}/${QTW_P}" "${QTW_PN}" || die
}

src_configure() {
	eqmake5 PREFIX="${EPREFIX}/usr"
}

src_install() {
	# `default` attempts to install directly to /usr and parallelised
	# installation is not supported as `qmake5 -install` does not implictly
	# create target directory.

	emake -j1 INSTALL_ROOT="${ED}" install
	doman "packaging/debian/cool-retro-term.1"

	insinto "/usr/share/metainfo"
	doins "packaging/appdata/cool-retro-term.appdata.xml"
}
