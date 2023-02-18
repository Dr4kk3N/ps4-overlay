# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CMAKE_ECLASS="cmake"
PYTHON_COMPAT=( python3_{8..10} )
inherit cmake-multilib python-any-r1

# https://bugs.gentoo.org/show_bug.cgi?id=760777
MYCMAKEARGS="-DENABLE_PCH=OFF"

DESCRIPTION="Khronos reference front-end for GLSL and ESSL, and sample SPIR-V generator"
HOMEPAGE="https://www.khronos.org/opengles/sdk/tools/Reference-Compiler/ https://github.com/KhronosGroup/glslang"
SRC_URI="https://github.com/KhronosGroup/glslang/archive/${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64 ~x86"

LICENSE="BSD"
SLOT="0"

BDEPEND="${PYTHON_DEPS}"
