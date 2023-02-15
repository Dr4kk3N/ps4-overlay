# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3

DESCRIPTION="Support for extra binary formats"
HOMEPAGE="https://${PN}.nongnu.org/"
if [[ "${PV}" = 9999 ]]; then
	EGIT_REPO_URI="https://gitlab.com/cjwatson/${PN}.git"
else
	SRC_URI="https://gitlab.com/cjwatson/${PN}/-/archive/${PV}/${P}.tar.gz"
	KEYWORDS="amd64 x86"
fi

LICENSE="GPL-3+"
SLOT="0"
IUSE="systemd"

RDEPEND="systemd? ( sys-apps/systemd )"
DEPEND="
	dev-libs/libpipeline
	dev-vcs/git
	sys-devel/libtool
	virtual/pkgconfig"

src_unpack() {
	default

	cd "${S}" || die
	local GNULIB_URI="https://git.savannah.gnu.org/git/gnulib.git"
	local GNULIB_REVISION="$(. bootstrap.conf >/dev/null; echo "${GNULIB_REVISION}")"
	git-r3_fetch "${GNULIB_URI}" "${GNULIB_REVISION}"
	git-r3_checkout "${GNULIB_URI}" gnulib
}

src_prepare() {
	default
	./bootstrap
}

src_configure() {
	econf \
		--prefix=/usr \
		--sysconfdir=/etc \
		--localstatedir=/var \
		--enable-openrc \
		--disable-upstart \
		"$(use_enable systemd)"
}
