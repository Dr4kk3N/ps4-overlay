# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

inherit xdg git-r3

DESCRIPTION="OneUI4-Icons Theme is based on FLuent icon theme"

HOMEPAGE="https://github.com/end-4/OneUI4-Icons"

EGIT_REPO_URI="https://github.com/end-4/OneUI4-Icons.git"

LICENSE="GPL-3"
SLOT="0"

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""

DOCS=( README.md )

src_install() {
	# Remove dead links to fix symbolic link does not exist QA.
	find . -xtype l -exec rm {} + || die
	# Install the icons
	insinto /usr/share/icons
	doins -r OneUI*
}

