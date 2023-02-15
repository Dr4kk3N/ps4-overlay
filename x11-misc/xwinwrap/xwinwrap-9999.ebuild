# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic

DESCRIPTION="Utility to replace a desktop background with a movie, screensaver, etc"
KEYWORDS="~amd64"
LICENSE="HPND"
HOMEPAGE="https://github.com/ujjwal96/xwinwrap.git"
EGIT_REPO_URI="https://github.com/ujjwal96/xwinwrap.git"
SLOT="0"
IUSE=""

DEPEND=">=x11-libs/libX11-1.0.3
	>=x11-libs/libXrender-0.9.10-r1
	>=x11-libs/libXext-1.3.4
	>=x11-base/xorg-server-1.20.7"

RDEPEND="${DEPEND}"

src_build(){
	emake
}

src_install() {
	emake install
}