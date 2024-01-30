# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit font

DESCRIPTION="Clean and modern sans-serif typeface designed for legibility across interfaces"
HOMEPAGE="https://www.wfonts.com/font/open-sans-hebrew-condensed"
SRC_URI="https://www.wfonts.com/download/data/2016/07/12/open-sans-hebrew-condensed/open-sans-hebrew-condensed.zip"
# renamed from unversioned zip
S="${WORKDIR}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"

BDEPEND="app-arch/unzip"

FONT_SUFFIX="ttf"
