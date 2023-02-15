# Copyright 2020-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop toolchain-funcs

DESCRIPTION="Frontend for MAME/MESS"
HOMEPAGE="http://qmc2.arcadehits.net/wordpress/"
SRC_URI="https://github.com/qmc2/qmc2-mame-fe/archive/refs/tags/v0.243.tar.gz -> ${P}.tar.gz"

#http://sourceforge.net/projects/${PN}/files/${PN}/${PV}/${P}.tar.bz2/download -> ${P}.tar.bz2"
#https://github.com/yuzu-emu/yuzu-mainline/archive/d5f6201521cdfd0be09a187d62f95d3a38f18c3e.tar.gz -> ${P}.tar.gz
#https://github.com/qmc2/qmc2-mame-fe/archive/refs/tags/v0.243.tar.gz

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="debug +arcade joystick opengl tools"
RESTRICT="mirror"

RDEPEND=">=games-emulation/sdlmame-0.164[tools=]"
DEPEND="${RDEPEND}
	dev-qt/qtmultimedia:5[widgets]
	dev-qt/qtcore:5
	dev-qt/qtgui:5[accessibility]
	dev-qt/qtopengl:5
	dev-qt/qtsql:5[sqlite]
	dev-qt/qtsvg:5
	dev-qt/qttest:5
	dev-qt/qtwebengine:5
	dev-qt/qtxmlpatterns:5
	media-libs/libsdl
	net-misc/rsync
	sys-libs/zlib
	x11-apps/xwininfo
	arcade? ( dev-qt/qtdeclarative:5 )
	joystick? ( media-libs/libsdl[joystick] )
	opengl? ( dev-qt/qtopengl:5 )
	tools? ( dev-qt/qtscript )"

S="${WORKDIR}/${PN}"

src_prepare() {
	# *.desktop files belong in /usr/share/applications, not /usr/share/games/applications #
	sed -e "s:\$(GLOBAL_DATADIR)/applications:${ED}usr/share/applications:g" \
		-i Makefile || die
}

src_compile() {
	FLAGS="DESTDIR=\"${ED}\" PREFIX=\"${GAMES_PREFIX}\" SYSCONFDIR=\"${GAMES_SYSCONFDIR}\" DATADIR=\"${GAMES_DATADIR}\" CTIME=0"
	emake ${FLAGS} \
		DEBUG=$(usex debug "1" "0") \
		JOYSTICK=$(usex joystick "1" "0") \
		OPENGL=$(usex opengl "1" "0") \
		PHONON=$(usex phonon "1" "0")

	use arcade && \
		emake ${FLAGS} arcade

	use tools && \
		emake ${FLAGS} tools
}

src_install() {
	emake ${FLAGS} install

	use arcade && \
		emake ${FLAGS} arcade-install

	use tools && \
		emake ${FLAGS} tools-install

	prepgamesdirs
}
