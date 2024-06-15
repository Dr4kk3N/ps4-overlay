# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="A lightweight calendar applet written in C++ using GTK"
HOMEPAGE="https://github.com/dmedvinsky/gsimplecal"
SRC_URI="https://github.com/dmedvinsky/gsimplecal/archive/refs/tags/v${PV}.tar.gz -> ${PN}-${PV}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="x11-libs/gtk+:3"
RDEPEND="${DEPEND}"
BDEPEND="dev-build/autoconf
		 virtual/pkgconfig"

S=$WORKDIR/$PF

src_prepare() {
		default
		eautoreconf
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc README NEWS AUTHORS ChangeLog
}

pkg_postinst() {
	elog "See 'man gsimplecal' for configuration options to use in ~/.config/gsimplecal/config"
}
