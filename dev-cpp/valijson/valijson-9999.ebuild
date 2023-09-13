# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake


MY_PN=valijson

if [[ ${PV} == *9999* ]]; then
	EGIT_REPO_URI="https://github.com/tristanpenman/${MY_PN}.git"
	inherit git-r3
else
	SRC_URI="https://github.com/tristanpenman/valijson/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~x86"
fi

DESCRIPTION="Header-only C++ library for JSON Schema validation"
HOMEPAGE="https://github.com/tristanpenman/valijson"

LICENSE="BSD-2 Boost-1.0"
SLOT="0"
KEYWORDS="amd64 ~arm64 x86"
RESTRICT="test"

#src_install() {
#	# there is no target for installing headers, so do it manually
#	doheader -r include/*
#}
