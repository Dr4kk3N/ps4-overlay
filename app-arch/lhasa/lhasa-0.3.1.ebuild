# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Lhasa aims to be compatible with as many types of lzh/lzs archives as possible."
HOMEPAGE="https://fragglet.github.io/lhasa/"
SRC_URI="https://soulsphere.org/projects/${PN}/${P}.tar.gz"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="!app-arch/lha"

src_prepare() {
	default
	eautoreconf
}

src_install() {
	default
	find "${ED}" -type f -name '*.la' -delete || die
	dodoc AUTHORS ChangeLog INSTALL NEWS README TODO
}
