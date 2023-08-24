# Copyright 1999-2023 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Virtual of a R recommended package"
HOMEPAGE=""
SRC_URI=""

LICENSE=""
SLOT="0"
KEYWORDS="~amd64 ~x86 ~arm64-macos ~x64-macos"
IUSE=""

RDEPEND="
        || (
		dev-lang/R[-minimal]
		sci-CRAN/MASS
        )"
