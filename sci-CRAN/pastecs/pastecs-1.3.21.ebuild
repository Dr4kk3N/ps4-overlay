# Copyright 1999-2020 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit R-packages

DESCRIPTION='Package for Analysis of Space-Ti... (see metadata)'
KEYWORDS="~amd64"
SRC_URI="http://cran.r-project.org/src/contrib/pastecs_1.3.21.tar.gz"
LICENSE='GPL-2'

IUSE="${IUSE-} r_suggests_covr r_suggests_svunit"
R_SUGGESTS="
	r_suggests_covr? ( sci-CRAN/covr )
	r_suggests_svunit? ( sci-CRAN/svUnit )
"
DEPEND="virtual/boot"
RDEPEND="${DEPEND-} ${R_SUGGESTS-}"
