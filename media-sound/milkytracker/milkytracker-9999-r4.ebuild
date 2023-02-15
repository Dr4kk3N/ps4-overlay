# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake git-r3

DESCRIPTION="FastTracker 2 inspired music tracker"
HOMEPAGE="http://milkytracker.org/"

EGIT_MIN_CLONE_TYPE="shallow"
EGIT_REPO_URI="https://github.com/${PN}/MilkyTracker.git"
EGIT_BRANCH="master"
EGIT_SUBMODULES=()
SRC_URI=""

LICENSE="|| ( GPL-3 MPL-1.1 ) AIFFWriter.m BSD GPL-3 GPL-3+ LGPL-2.1+ MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="alsa jack midi"

RDEPEND="
	app-arch/lhasa
	>=media-libs/libsdl-1.2:=[X]
	alsa? ( media-libs/alsa-lib:= )
	jack? ( media-sound/jack-audio-connection-kit:= )
	midi? ( media-libs/rtmidi )
	sys-libs/zlib:=
"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-fix-docs.patch
	"${FILESDIR}"/${P}-raise_cpp_standard.patch
)

src_install() {
	cmake_src_install

	dodoc AUTHORS ChangeLog.md docs/{readme_unix,TiTAN.nfo}
	dodoc docs/{FAQ,MilkyTracker}.html

	newicon resources/pictures/carton.png ${PN}.png
	make_desktop_entry ${PN} MilkyTracker ${PN} \
		"AudioVideo;Audio;Sequencer"
}
