# Copyright 1999-2023 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit R-packages

DESCRIPTION='General Network (HTTP/FTP/...) C... (see metadata)'
KEYWORDS="~amd64"
SRC_URI="http://cran.r-project.org/src/contrib/RCurl_1.98-1.12.tar.gz"
LICENSE='BSD'

IUSE="${IUSE-} r_suggests_xml"
R_SUGGESTS="r_suggests_xml? ( sci-CRAN/XML )"
DEPEND=">=dev-lang/R-3.4.0
	sci-CRAN/bitops
"
RDEPEND="${DEPEND-}
	net-misc/curl
	${R_SUGGESTS-}
"
