# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=7

MY_PN="ROCT-Thunk-Interface"
MY_PV="roc-${PV}"

DESCRIPTION="Radeon Open Compute Thunk Interface"
HOMEPAGE="http://gpuopen.com/professional-compute/rocm/"
SRC_URI="https://github.com/RadeonOpenCompute/${MY_PN}/archive/${MY_PV}.tar.gz -> ${MY_PN}-${MY_PV}.tar.gz"

LICENSE="MIT"

SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="dev-build/make"
RDEPEND=""

S="${WORKDIR}/${MY_PN}-${MY_PV}"

src_install() {
	dolib build/lnx64a/libhsakmt.so.1
	dosym libhsakmt.so.1 /usr/$(get_libdir)/libhsakmt.so

	insinto /usr/include/hsathk
	doins -r include/*
}
