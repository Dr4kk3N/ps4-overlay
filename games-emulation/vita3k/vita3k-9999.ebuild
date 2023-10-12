# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3 cmake

DESCRIPTION="Sony Playstation Vita Emulator"
HOMEPAGE="https://vita3k.org"
EGIT_REPO_URI="https://github.com/Vita3K/Vita3K.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND="
	dev-vcs/git
	sys-devel/gcc
	dev-util/ninja
	dev-util/cmake
	"
