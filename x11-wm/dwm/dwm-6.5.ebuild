# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit savedconfig toolchain-funcs

DESCRIPTION="a dynamic window manager for X11"
HOMEPAGE="https://dwm.suckless.org/"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://git.suckless.org/dwm"
else
	SRC_URI="https://dl.suckless.org/${PN}/${P}.tar.gz"
	KEYWORDS="amd64 ~arm arm64 ppc ppc64 ~riscv x86"
fi

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ppc ~ppc64 x86"
IUSE="attachaside alphaborder barpadding center emojis hidevacanttags pertag personal restartsig roundedcorners systray vanitygaps xinerama"

RDEPEND="
	media-libs/fontconfig
	x11-libs/libX11
	>=x11-libs/libXft-2.3.5
	xinerama? ( x11-libs/libXinerama )
"
DEPEND="
	${RDEPEND}
	roundedcorners? (
		x11-libs/libXext
		x11-libs/libxcb
	)
	x11-base/xorg-proto
	xinerama? ( x11-base/xorg-proto )
"

src_prepare() {
	default

	sed -i \
		-e "s/ -Os / /" \
		-e "/^\(LDFLAGS\|CFLAGS\|CPPFLAGS\)/{s| = | += |g;s|-s ||g}" \
		-e "/^X11LIB/{s:/usr/X11R6/lib:/usr/$(get_libdir)/X11:}" \
		-e '/^X11INC/{s:/usr/X11R6/include:/usr/include/X11:}' \
		config.mk || die

	eapply "${FILESDIR}/config.patch"
	eapply_user

	if use attachaside; then
		sed -i -e 's/ATTACHASIDEFLAGS =.*/ATTACHASIDEFLAGS = -DATTACHASIDE/g' config.mk || die
	else
		sed -i -e 's/ATTACHASIDEFLAGS =.*/ATTACHASIDEFLAGS = /g' config.mk || die
	fi
	if use alphaborder; then
		sed -i -e 's/ALPHABORDERFLAGS =.*/ALPHABORDERFLAGS = -DALPHABORDER/g' config.mk || die
	else
		sed -i -e 's/ALPHABORDERFLAGS =.*/ALPHABORDERFLAGS = /g' config.mk || die
	fi
	if use barpadding; then
		sed -i -e 's/BARPADDING =.*/BARPADDINGFLAGS = -DBARPADDING/g' config.mk || die
	else
		sed -i -e 's/BARPADDINGFLAGS =.*/BARPADDINGFLAGS = /g' config.mk || die
	fi
	if use center; then
		sed -i -e 's/CENTERFLAGS =.*/CENTERFLAGS = -DCENTER/g' config.mk || die
	else
		sed -i -e 's/CENTERFLAGS =.*/CENTERFLAGS = /g' config.mk || die
	fi
	if use emojis; then
		sed -i -e 's/EMOJISFLAGS =.*/EMOJISFLAGS = -DEMOJIS/g' config.mk || die
	else
		sed -i -e 's/EMOJISFLAGS =.*/EMOJISFLAGS = /g' config.mk || die
	fi
	if use hidevacanttags; then
		sed -i -e 's/HIDEVACANTTAGSFLAGS =.*/HIDEVACANTTAGSFLAGS = -DHIDEVACANTTAGS/g' config.mk || die
	else
		sed -i -e 's/HIDEVACANTTAGSFLAGS =.*/HIDEVACANTTAGSFLAGS = /g' config.mk || die
	fi
	if use personal; then
		sed -i -e 's/PERSONALFLAGS =.*/PERSONALFLAGS = -DPERSONAL/g' config.mk || die
	else
		sed -i -e 's/PERSONALFLAGS =.*/PERSONALFLAGS = /g' config.mk || die
	fi
	if use pertag; then
		sed -i -e 's/PERTAGFLAGS =.*/PERTAGFLAGS = -DPERTAG/g' config.mk || die
	else
		sed -i -e 's/PERTAGFLAGS =.*/PERTAGFLAGS = /g' config.mk || die
	fi
	if use restartsig; then
		sed -i -e 's/RESTARTSIGFLAGS =.*/RESTARTSIGFLAGS = -DRESTARTSIG/g' config.mk || die
	else
		sed -i -e 's/RESTARTSIGFLAGS =.*/RESTARTSIGFLAGS = /g' config.mk || die
	fi
	if use roundedcorners; then
		sed -i -e 's/ROUNDEDCORNERSFLAGS =.*/ROUNDEDCORNERSFLAGS = -DROUNDEDCORNERS/g' config.mk || die
		sed -i -e 's/ROUNDEDCORNERSLIBS =.*/ROUNDEDCORNERSLIBS = -lxcb -lxcb-shape/g' config.mk || die
	else
		sed -i -e 's/ROUNDEDCORNERSFLAGS =.*/ROUNDEDCORNERSFLAGS = /g' config.mk || die
		sed -i -e 's/ROUNDEDCORNERSLIBS =.*/ROUNDEDCORNERSLIBS = /g' config.mk || die
	fi
	if use systray; then
		sed -i -e 's/SYSTRAYFLAGS =.*/SYSTRAYFLAGS = -DSYSTRAY/g' config.mk || die
	else
		sed -i -e 's/SYSTRAYFLAGS =.*/SYSTRAYFLAGS = /g' config.mk || die
	fi
	if use vanitygaps; then
		sed -i -e 's/VANITYGAPSFLAGS =.*/VANITYGAPSFLAGS = -DVANITYGAPS/g' config.mk || die
	else
		sed -i -e 's/VANITYGAPSFLAGS =.*/VANITYGAPSFLAGS = /g' config.mk || die
	fi

	restore_config config.h
}

src_compile() {
	if use xinerama; then
		emake CC="$(tc-getCC)" dwm
	else
		emake CC="$(tc-getCC)" XINERAMAFLAGS="" XINERAMALIBS="" dwm
	fi
}

src_install() {
	emake DESTDIR="${D}" PREFIX="${EPREFIX}/usr" install

	exeinto /etc/X11/Sessions
	newexe "${FILESDIR}"/dwm-session2 dwm

	insinto /usr/share/xsessions
	doins "${FILESDIR}"/dwm.desktop

	dodoc README

	save_config config.h
}
