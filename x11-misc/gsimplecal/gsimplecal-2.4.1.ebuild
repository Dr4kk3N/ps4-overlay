# Copyright 1999-2022 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="8"

inherit autotools

DESCRIPTION="A lightweight calendar designed for tint2"
HOMEPAGE="https://github.com/dmedvinsky/gsimplecal"
EGIT_REPO_URI="https://github.com/dmedvinsky/gsimplecal.git"
SRC_URI="https://github.com/dmedvinsky/${PN}/archive/v${PV}.tar.gz -> ${PN}-${PV}.tar.gz"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="x11-libs/gtk+:2"
DEPEND="${RDEPEND}
	dev-util/pkgconf
	>=sys-devel/autoconf-2.65"

S=$WORKDIR/$PF

src_prepare() {
	default
	eautoreconf
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc README NEWS AUTHORS ChangeLog
}
