# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

if [[ ${PV} != *9999* ]]; then
	QT6_KDEPATCHSET_REV=1
	KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc64 ~riscv ~x86"
fi

inherit qt6-build

DESCRIPTION="Text-to-speech library for the Qt6 framework"

IUSE="alsa flite"

RDEPEND="
	>=app-accessibility/speech-dispatcher-0.8.7
	=dev-qt/qtbase-${PV}*
	flite? (
		>=app-accessibility/flite-2[alsa?]
		=dev-qt/qtmultimedia-${PV}*[alsa?]
		alsa? ( media-libs/alsa-lib )
	)
"
DEPEND="${RDEPEND}"

src_prepare() {
	qt_use_disable_config flite flite \
		src/plugins/tts/tts.pro

	qt_use_disable_config alsa flite_alsa \
		src/plugins/tts/flite/flite.pro

	qt6-build_src_prepare
}
