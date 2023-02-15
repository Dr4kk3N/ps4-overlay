# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Fork of the popular zip manipulation library found in the zlib distribution."
HOMEPAGE="https://github.com/zlib-ng/minizip-ng"
SRC_URI="https://github.com/zlib-ng/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="AS-IS"
SLOT="0"
#KEYWORDS="~amd64 ~x86"

IUSE="compat test"

RESTRICT="!test? ( test )"

BDEPEND="
    app-arch/bzip2
    app-arch/lzma
    app-arch/zstd
    sys-libs/zlib-ng
"
DEPEND="${RDEPEND} ${BDEPEND}"

src_configure() {
	local mycmakeargs=(
		-DMZ_COMPAT="$(usex compat)"
		-DMZ_BUILD_TESTS="$(usex test)" 
	)
	
	if use compat; then 
	    local mycmakeargs=(-DMZ_ZLIB="OFF")
	fi

	cmake_src_configure
}

src_install() {
	cmake_src_install

	if use compat ; then
		ewarn "minizip-ng is experimental and replacing the system zlib[minizip] is dangerous"
		ewarn "Please be careful!"
	fi
}
