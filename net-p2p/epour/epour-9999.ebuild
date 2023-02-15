# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_10 )

inherit eutils distutils-r1
[ "${PV}" = 9999 ] && inherit git-r3

DESCRIPTION="Enlightenment torrent client"
HOMEPAGE="https://www.enlightenment.org/about-epour"
EGIT_REPO_URI="https://git.enlightenment.org/enlightenment/${PN}.git"

LICENSE="BSD-2"
[ "${PV}" = 9999 ] || KEYWORDS="~amd64 ~x86"
SLOT="0"

IUSE=""
RDEPEND="	>=dev-libs/efl-1.15.0
		~dev-python/python-efl-9999[${PYTHON_USEDEP}]
		>=net-libs/libtorrent-rasterbar-1.0.10
		sys-apps/dbus
		x11-misc/xdg-utils"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${P/_/-}"

src_install() {
	distutils-r1_src_install
	# README.txt gets installed twice
	rm -r "${ED%/}"/usr/share/doc/"${PN}" || die "failed to remove dir"
}
