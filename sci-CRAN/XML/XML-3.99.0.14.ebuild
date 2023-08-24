# Copyright 1999-2023 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit R-packages

DESCRIPTION='Tools for Parsing and Generating... (see metadata)'
KEYWORDS="~amd64"
SRC_URI="http://cran.r-project.org/src/contrib/XML_3.99-0.14.tar.gz"
LICENSE='BSD'

IUSE="${IUSE-} r_suggests_bitops r_suggests_rcurl"
R_SUGGESTS="
	r_suggests_bitops? ( sci-CRAN/bitops )
	r_suggests_rcurl? ( sci-CRAN/RCurl )
"
DEPEND=">=dev-lang/R-4.0.0"
RDEPEND="${DEPEND-}
	dev-libs/libxml2
	${R_SUGGESTS-}
"
