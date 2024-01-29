# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3

DESCRIPTION="EmulationStation theme nbba"
HOMEPAGE="https://github.com/RetroPie/es-theme-nbba"
SRC_URI=""
EGIT_REPO_URI="https://github.com/RetroPie/es-theme-nbba"

LICENSE="CC-BY-NC-SA-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}"

src_install() {
	# Install documentation.
	dodoc readme.txt

	# Prevent documentation and the ".git" subdirectory from being installed
	# below.
	rm -R readme.txt .git* || die '"rm" failed.'

	# Install all remaining files and subdirectories.
	insinto /etc/emulationstation/themes/nbba
	doins -r *
}
