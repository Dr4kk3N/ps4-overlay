# Copyright 1999-2023 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit R-packages

DESCRIPTION='Vector Helpers'
KEYWORDS="~amd64 ~arm64-macos ~x64-macos"
SRC_URI="http://cran.r-project.org/src/contrib/vctrs_0.6.3.tar.gz"
LICENSE='MIT'

IUSE="${IUSE-} r_suggests_bit64 r_suggests_covr r_suggests_crayon
	r_suggests_dplyr r_suggests_generics r_suggests_knitr
	r_suggests_pillar r_suggests_rmarkdown r_suggests_testthat
	r_suggests_tibble r_suggests_waldo r_suggests_withr r_suggests_xml2
	r_suggests_zeallot"
R_SUGGESTS="
	r_suggests_bit64? ( sci-CRAN/bit64 )
	r_suggests_covr? ( sci-CRAN/covr )
	r_suggests_crayon? ( sci-CRAN/crayon )
	r_suggests_dplyr? ( >=sci-CRAN/dplyr-0.8.5 )
	r_suggests_generics? ( sci-CRAN/generics )
	r_suggests_knitr? ( sci-CRAN/knitr )
	r_suggests_pillar? ( >=sci-CRAN/pillar-1.4.4 )
	r_suggests_rmarkdown? ( sci-CRAN/rmarkdown )
	r_suggests_testthat? ( >=sci-CRAN/testthat-3.0.0 )
	r_suggests_tibble? ( >=sci-CRAN/tibble-3.1.3 )
	r_suggests_waldo? ( >=sci-CRAN/waldo-0.2.0 )
	r_suggests_withr? ( sci-CRAN/withr )
	r_suggests_xml2? ( sci-CRAN/xml2 )
	r_suggests_zeallot? ( sci-CRAN/zeallot )
"
DEPEND=">=dev-lang/R-3.5.0
	sci-CRAN/glue
	>=sci-CRAN/rlang-1.1.0
	>=sci-CRAN/lifecycle-1.0.3
	>=sci-CRAN/cli-3.4.0
"
RDEPEND="${DEPEND-} ${R_SUGGESTS-}"

_UNRESOLVED_PACKAGES=( '>=sci-CRAN/pkgdown-2.0.1' )
