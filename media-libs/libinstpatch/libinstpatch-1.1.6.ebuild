# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Library for processing digital sample based MIDI instrument patch files."
HOMEPAGE="https://github.com/swami/libinstpatch"
SRC_URI="https://github.com/swami/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

inherit cmake

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-libs/glib
	media-libs/libsndfile
	dev-python/pygobject"

DEPEND="${RDEPEND}"
