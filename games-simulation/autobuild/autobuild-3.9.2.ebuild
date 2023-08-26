# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=(python3_11)
DISTUTILS_USE_SETUPTOOLS=rdepend

inherit eutils distutils-r1 git-r3

DESCRIPTION="A framework for building packages and for managing the dependencies"
HOMEPAGE="https://github.com/secondlife/autobuild"
SRC_URI="https://github.com/secondlife/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

RDEPEND="
	${PYTHON_DEPS}
"
DEPEND="
	dev-python/pydot[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	games-simulation/llbase[${PYTHON_USEDEP}]
	${RDEPEND}
"

DOCS="README.md"

distutils_enable_tests nose
