# Copyright 1999-2023 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit R-packages

DESCRIPTION='Manipulate and Play ProTracker Modules'
KEYWORDS="~amd64 ~x64-macos ~arm64-macos"
SRC_URI="http://cran.r-project.org/src/contrib/ProTrackR_0.3.8.tar.gz"
LICENSE='GPL-3'

IUSE="${IUSE-} r_suggests_amigaffh"
R_SUGGESTS="r_suggests_amigaffh? ( >=sci-CRAN/AmigaFFH-0.2.0 )"
DEPEND="virtual/lattice
	>=sci-CRAN/tuneR-1.0
	sci-CRAN/signal
	sci-CRAN/XML
	sci-CRAN/audio
"
RDEPEND="${DEPEND-} ${R_SUGGESTS-}"
