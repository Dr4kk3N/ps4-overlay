# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_P="${P/_/-}"
S="${WORKDIR}/${MY_P}"
DESCRIPTION="Audacious Player - Your music, your way, no exceptions"
HOMEPAGE="https://audacious-media-player.org/"

if [[ ${PV} == "9999" ]]; then
	EGIT_REPO_URI="https://github.com/audacious-media-player/${PN}.git"
	inherit git-r3
else
	KEYWORDS="~amd64 ~x86"
	SRC_URI="https://distfiles.audacious-media-player.org/${MY_P}.tar.bz2"
fi

inherit meson xdg

LICENSE="BSD-2 BSD CC-BY-SA-4.0"
SLOT="0/5.4.0"

IUSE="+dbus gtk gtk3 libarchive +qt5"
REQUIRED_USE="|| ( dbus gtk qt5 )"

QT_REQ="5.2:5="
RDEPEND="
	>=dev-libs/glib-2.32
	dbus? ( sys-apps/dbus )
	libarchive? ( app-arch/libarchive )
	gtk? (
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
		>=dev-qt/qtcore-${QT_REQ}
		>=dev-qt/qtgui-${QT_REQ}
		>=dev-qt/qtwidgets-${QT_REQ}
		virtual/freedesktop-icon-theme
	)"
DEPEND="${RDEPEND} virtual/pkgconfig"
BDEPEND="
	sys-devel/gettext
	dbus? ( dev-util/gdbus-codegen )"
PDEPEND="~media-plugins/audacious-plugins-${PV}"

src_configure() {
	local emesonargs=(
		"--auto-features=disabled"
		"$(meson_use dbus)"
		"$(meson_use "$(usex gtk3 gtk3 gtk)" gtk)"
		"$(meson_use gtk3)"
		"$(meson_use libarchive)"
		"$(meson_use qt5 qt)"
		"-Dqt6=false" # soon
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
