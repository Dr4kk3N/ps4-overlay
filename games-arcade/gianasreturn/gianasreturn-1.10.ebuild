# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop wrapper

DESCRIPTION="Unofficial sequel of The Great Giana Sisters"
HOMEPAGE="http://www.gianas-return.de/"
SRC_URI="http://www.retroguru.com/gianas-return/gianas-return-v.latest-linux.tar.gz -> ${PN}-v${PV}-linux.tar.gz"

LICENSE="free-noncomm"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="strip"
RDEPEND="media-libs/libsdl
	media-libs/sdl-mixer[flac,mad,mikmod,vorbis]
	sys-libs/zlib"

S="${WORKDIR}/giana"

src_install() {
	local dir="/opt/${PN}"
	local bin

	use amd64 && bin="giana_linux64"
	use x86 && bin="giana_linux32"

	insinto "${dir}"
	doins -r data || die "doins failed"
	exeinto "${dir}"
	doexe "${bin}" || die "doexe failed"

	make_wrapper gianasreturn ./"${bin}" "${dir}" "${dir}"
	doicon giana.png
	make_desktop_entry gianasreturn "Giana's Return" giana
	dodoc {config,options,readme}.txt
}
