# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KFMIN=6.0
QTMIN=6.6.2

inherit ecm plasma.kde.org edo

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/Schneegans/Burn-My-Windows.git"
else
	SRC_URI="https://github.com/Schneegans/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="-* ~amd64"
fi

DESCRIPTION="Disintegrate your windows with style"
HOMEPAGE="https://github.com/Schneegans/Burn-My-Windows"

LICENSE="GPL-3"
SLOT="6"

DEPEND="
	>=kde-plasma/kwin-6.0.0:6
	>=dev-qt/qtbase-${QTMIN}:6=[gui,opengl,widgets]
"
RDEPEND="${DEPEND}"
BDEPEND="
	dev-lang/perl
        sys-devel/gettext
"
# PATCHES=( "${FILESDIR}/36-blacklist-spectacle.patch" )

src_prepare() {
	default

	# do not create tarball
	sed -i '/tar/d' kwin/build.sh || die "sed failed"
}

src_configure() { :; }

src_compile() {
	edo kwin/build.sh
}

src_install() {
	einstalldocs

	insinto /usr/share/kwin/effects
	doins -r kwin/_build/.
}
