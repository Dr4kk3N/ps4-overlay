# Copyright 2022 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3

DESCRIPTION="Precision and speed oriented cursor theme"
HOMEPAGE="https://hacktivis.me/projects/ultrasharp-cursor-theme"
EGIT_REPO_URI="https://hacktivis.me/git/ultrasharp-cursor-theme.git"
EGIT_MIN_CLONE_TYPE="single+tags"
LICENSE="CC-BY-SA-4.0"
SLOT="0"

src_prepare() {
	default

	sed -i 's/^install: all/install:/' Makefile || die
}

src_compile() {
	:
}
