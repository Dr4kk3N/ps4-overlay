# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/saivert/pwvucontrol/pwvucontrol.git"
else
	SRC_URI="https://github.com/saivert/pwvucontrol/archive/refs/tags/${PV}.tar.gz -- ${PN}.${PV}.tar.xz"
	KEYWORDS="-* ~amd64"
fi

DESCRIPTION="Pulseaudio Volume Control, GTK 4 based mixer for Pipewire"
HOMEPAGE="https://github.com/saivert/pwvucontrol"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 arm ~arm64 ~hppa ~loong ppc ~ppc64 ~riscv ~sparc x86"
IUSE="nls X"

#PATCHES=(
#	"${FILESDIR}/${PN}-5.0-make-libcanberra-optional.patch"
#)

RDEPEND="
	X? (
		>=dev-cpp/glib-2.66:3.0[X]
		>=dev-cpp/gio-2.66
		>=media-libs/gtk4-4.0.0
	)
	>=dev-libs/libsigc++-2.2:2
	>=media-libs/libpulse-15.0[glib]
	virtual/freedesktop-icon-theme
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	nls? (
		dev-util/intltool
		sys-devel/gettext
	)
"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		$(use_enable nls)
	)
	econf "${myeconfargs[@]}"
}
