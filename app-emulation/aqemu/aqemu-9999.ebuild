# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake git-r3

DESCRIPTION="Graphical interface for QEMU and KVM emulators, using Qt5"
HOMEPAGE="https://sourceforge.net/projects/aqemu"
EGIT_REPO_URI="https://github.com/tobimensch/${PN}.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="vnc"

RDEPEND="
	app-emulation/qemu
	dev-qt/qtcore:5
	dev-qt/qtnetwork:5
	dev-qt/qtprintsupport:5
	dev-qt/qttest:5
	dev-qt/qtwidgets:5
	vnc? ( net-libs/libvncserver )
"
DEPEND="${RDEPEND}"

#DOCS=( AUTHORS CHANGELOG README TODO )

src_configure() {
	local mycmakeargs=(
		-DMAN_PAGE_COMPRESSOR=""
		-DWITHOUT_EMBEDDED_DISPLAY=$(usex vnc OFF ON)
	)

	cmake_src_configure
}
