# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

inherit git-r3

#S="${WORKDIR}/codedwrench-sources-5.15.15"
#detect_version
#detect_arch

EGIT_REPO_URI="https://github.com/codedwrench/ps4-linux.git"
EGIT_CLONE_TYPE="shallow"

DESCRIPTION="The very latest -git version of the Codedwrench PS4 Linux kernel"
HOMEPAGE="https://github.com/codedwrench/ps4-linux"

KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE="experimental baikal 2.3Ghz"

K_EXTRAEINFO="This kernel is not supported by Gentoo due to its unstable and
experimental nature."

RDEPEND=""
DEPEND="${RDEPEND}"
#	>=sys-devel/patch-2.7.6-r4"

src_unpack() {
	git-r3_src_unpack
}

src_prepare() {
	eapply_user
}

src_compile() {
	:;
}

src_install() {
	dodir /usr/src/
	cp -R "${S}/" "${D}/usr/src/" || die "Install failed!"
}

