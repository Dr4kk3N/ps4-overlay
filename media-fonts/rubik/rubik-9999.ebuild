# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit fontmake git-r3

FONTDIR_BIN=( fonts/variable )

EGIT_REPO_URI="https://github.com/googlefonts/${PN}.git"

DESCRIPTION="A sans serif font family with slightly rounded corners"
HOMEPAGE="https://github.com/googlefonts/${PN}"

LICENSE="OFL-1.1"
SLOT="0"
REQUIRED_USE+="
	binary? (
		variable
		font_types_ttf
	)
"
