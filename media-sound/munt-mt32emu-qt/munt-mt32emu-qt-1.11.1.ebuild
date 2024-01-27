# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit cmake xdg

MY_P="mt32emu_qt_${PV//./_}"
DESCRIPTION="software synthesiser emulating pre-GM MIDI devices (Roland MT-32)"
HOMEPAGE="https://github.com/munt/munt"
SRC_URI="https://github.com/munt/munt/archive/${MY_P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="alsa pulseaudio"

DEPEND="dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtmultimedia:5
	>=media-libs/munt-mt32emu-2.6.0
	alsa? ( media-libs/alsa-lib )
	pulseaudio? ( media-sound/pulseaudio )"
RDEPEND="${DEPEND}"
S="${WORKDIR}/munt-${MY_P}/mt32emu_qt"

src_prepare() {
	sed -e "s#share/doc/munt/mt32emu-qt#share/doc/${PF}#" \
		-e "s#COPYING\(.LESSER\)\?.txt ##g" \
		-i CMakeLists.txt || die

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-Dmt32emu-qt_WITH_ALSA_MIDI_SEQUENCER=$(usex alsa)
		-Dmt32emu-qt_USE_PULSEAUDIO_DYNAMIC_LOADING=$(usex pulseaudio)
		-Dmt32emu-qt_WITH_QT5=ON
	)
	cmake_src_configure
}
