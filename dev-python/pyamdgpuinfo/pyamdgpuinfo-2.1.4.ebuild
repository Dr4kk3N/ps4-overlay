# Copyright 2020-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{9..11} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1

DESCRIPTION="AMD GPU information"
HOMEPAGE="https://github.com/mark9064/pyamdgpuinfo"
SRC_URI="https://github.com/mark9064/pyamdgpuinfo/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="x11-libs/libdrm[video_cards_amdgpu]"
RDEPEND="${DEPEND}"
BDEPEND="dev-python/cython[${PYTHON_USEDEP}]"

RESTRICT="test"
