# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils git-r3

DESCRIPTION="an open source fighting game engine that supports resources from the M.U.G.E.N engine"
HOMEPAGE="https://sourceforge.net/projects/openbor/"
EGIT_REPO_URI="https://github.com/ikemen-engine/Ikemen-GO"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="media-libs/sdl2-gfx"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${P}/engine

src_prepare() {
	sed -i 's/\<strdup/ob_strdup/g' $(find source -name "*.[ch]")
	eapply_user
}

src_compile() {
	make BUILD_LINUX=1 CC=gcc GCC_TARGET=x86_64 TARGET_ARCH=amd64 NO_RAM_DEBUGGER=1 NO_STRIP=1 || die
}

src_install() {
	dodoc COMPILING README
	doicon ${FILESDIR}/openbor.png
	newbin OpenBOR ${PN}-bin
	make_wrapper ${PN} ${PN}-bin /var/games/${PN}
	keepdir /var/games/${PN}/{Logs,Paks,Saves,ScreenShots}

	fowners root:games /var/games/${PN}/{Logs,Paks,Saves,ScreenShots}
	fperms 770 /var/games/${PN}/{Logs,Paks,Saves,ScreenShots}
}

pkg_postinst() {
elog "Install new games under directory: /var/games/${PN}/Paks"
}
