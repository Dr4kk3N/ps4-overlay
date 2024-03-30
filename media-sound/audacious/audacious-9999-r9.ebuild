# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_P="${P/_/-}"

DESCRIPTION="Audacious Player - Your music, your way, no exceptions"
HOMEPAGE="https://audacious-media-player.org/"
S="${WORKDIR}/${MY_P}"
LICENSE="BSD-2 BSD CC-BY-SA-4.0"
SLOT="0/5.5.0"
IUSE="+dbus gtk2 gtk3 libarchive qt5 +qt6"

if [[ ${PV} == "9999" ]]; then
	# This ebuild revision is for 784d518581 or later
	EGIT_REPO_URI="https://github.com/audacious-media-player/${PN}.git"
	inherit git-r3
else
	SRC_URI="https://distfiles.audacious-media-player.org/${MY_P}.tar.bz2"
	KEYWORDS="~amd64 ~x86"
fi

inherit meson xdg

REQUIRED_USE="|| ( dbus gtk2 gtk3 qt5 qt6 ) ^^ ( qt5 qt6 )"

RDEPEND="
	>=dev-libs/glib-2.32
	dbus? ( sys-apps/dbus )
	libarchive? ( app-arch/libarchive )
	gtk2? (
		>=x11-libs/gtk+-2.24:2
		x11-libs/cairo
		x11-libs/pango
		virtual/libintl
	)
	gtk3? (
		>=x11-libs/gtk+-3.22:3
		x11-libs/cairo
		x11-libs/pango
		virtual/libintl
	)
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtwidgets:5
		virtual/freedesktop-icon-theme
	)
	qt6? (
		dev-qt/qtbase:6[gui,widgets]
	)"
DEPEND="${RDEPEND} virtual/pkgconfig"
BDEPEND="
	sys-devel/gettext
	dbus? ( dev-util/gdbus-codegen )"
PDEPEND="~media-plugins/audacious-plugins-${PV}[gtk2(-)?,gtk3(-)?,qt5(-)?,qt6(-)?]"

src_configure() {
	local emesonargs=(
		"--auto-features=disabled"
		"$(meson_use "$(usex gtk3 gtk3 gtk2)" gtk)"
		"$(meson_use "$(usex qt6 qt6 qt5)" qt)"
		"$(meson_use dbus)"
		"$(meson_use gtk3)"
		"$(meson_use libarchive)"
		"$(meson_use qt5)"
	)
	meson_src_configure
}

src_install() {
	meson_src_install

	# install useful files from contrib/
	insinto /usr/share/metainfo
	doins contrib/audacious.appdata.xml

	insinto /usr/share/Thunar/sendto/
	newins {contrib/thunar-sendto-,}audacious-playlist.desktop

	use dbus && dodoc contrib/xchat-audacious.py
}

pkg_preinst() {
	xdg_pkg_preinst

	# make sure this matches, or else we'll create preserved-libs litter
	test -e "${D}"/usr/lib*/libaudcore.so."${SLOT##*/}" ||
		eqawarn "Subslot in ebuild needs updating"
}

pkg_postinst() {
	if ! use dbus; then
		einfo "D-Bus in ${PN} is a completely optional dependency and disabling it is supported,"
		einfo "however you do lose the following:"
		einfo " - Remote control (/usr/bin/audtool)"
		einfo "If you find something broken as a result of building without it,"
		einfo "get in touch so we can document it here. Have fun!"
	fi
}
