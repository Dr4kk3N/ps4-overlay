# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop git-r3

DESCRIPTION="The ultimate 2D side scrolling engine"
HOMEPAGE="https://sourceforge.net/projects/openbor/"
EGIT_REPO_URI="https://github.com/DCurrent/openbor"
#ESVN_REPO_URI="svn://svn.code.sf.net/p/openbor/engine"

LICENSE="BSD"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="media-libs/sdl2-gfx"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${P}/engine

src_prepare() {
	sed -i -e '/-Werror/d' Makefile || die
	sed -i 's/\<strdup/ob_strdup/g' $(find source -name "*.[ch]")
	sh environ.sh 4 || die
	sh version.sh || die
	eapply_user
}

src_compile() {
	make BUILD_LINUX=1 CC=gcc GCC_TARGET=x86_64 TARGET_ARCH=amd64 NO_RAM_DEBUGGER=1 NO_STRIP=1 || die
}

src_install() {
	dodoc COMPILING README
	newbin OpenBOR ${PN}-bin
	doicon "${FILESDIR}/openbor.png"
        domenu "${FILESDIR}/openbor.desktop"
#	make_wrapper ${PN} ${PN}-bin /var/games/${PN}
	keepdir /var/games/${PN}/{Logs,Paks,Saves,ScreenShots}

	fowners root:users /var/games/${PN}/{Logs,Paks,Saves,ScreenShots}
	fperms 770 /var/games/${PN}/{Logs,Paks,Saves,ScreenShots}
}

pkg_postinst() {
elog "Install new games under directory: /var/games/${PN}/Paks"
}

