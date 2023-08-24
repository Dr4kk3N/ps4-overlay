# Copyright 1999-2023 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit R-packages

DESCRIPTION='Commodore Amiga File Format Handler'
KEYWORDS="~amd64 ~x64-macos ~arm64-macos"
SRC_URI="http://cran.r-project.org/src/contrib/AmigaFFH_0.4.2.tar.gz"
LICENSE='GPL-3'

IUSE="${IUSE-} r_suggests_adfexplorer r_suggests_protrackr"
R_SUGGESTS="
	r_suggests_adfexplorer? ( >=sci-CRAN/adfExplorer-0.1.4 )
	r_suggests_protrackr? ( >=sci-CRAN/ProTrackR-0.3.4 )
"
DEPEND=">=sci-CRAN/tuneR-1.0
	sci-CRAN/vctrs
"
RDEPEND="${DEPEND-} ${R_SUGGESTS-}"
