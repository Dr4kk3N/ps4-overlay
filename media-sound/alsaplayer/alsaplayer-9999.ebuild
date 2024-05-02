# Copyright 1999-2021 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3 autotools xdg-utils

EGIT_REPO_URI="https://github.com/alsaplayer/alsaplayer.git"

DESCRIPTION="Media player primarily utilising ALSA"
HOMEPAGE="http://www.alsaplayer.org/"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="alsa doc flac gtk jack mad mikmod nas nls ogg opengl oss vorbis systray xosd"

RDEPEND="media-libs/libsndfile
	alsa? ( media-libs/alsa-lib )
	mad? ( media-libs/libmad )
	flac? ( media-libs/flac )
	jack? ( virtual/jack )
	mikmod? ( >=media-libs/libmikmod-3.1.10 )
	nas? ( media-libs/nas )
	ogg? ( media-libs/libogg )
	opengl? ( virtual/opengl )
	vorbis? ( media-libs/libvorbis )
	xosd? ( x11-libs/xosd )"

DEPEND="${RDEPEND}
	>=dev-libs/glib-2.10.1
	virtual/pkgconfig
	doc? ( app-doc/doxygen )
	nls? ( sys-devel/gettext )
	gtk? ( >=x11-libs/gtk+-2.8 )
	systray? ( >=x11-libs/gtk+-2.10 )"

DOCS=( AUTHORS ChangeLog README.md TODO docs/wishlist.txt )

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	use xosd || export ac_cv_lib_xosd_xosd_create="no"

	use doc || export ac_cv_prog_HAVE_DOXYGEN="false"

	econf \
		$(use_enable flac) \
		$(use_enable jack) \
		$(use_enable mad) \
		$(use_enable mikmod) \
		$(use_enable nas) \
		$(use_enable opengl) \
		$(use_enable oss) \
		$(use_enable nls) \
		$(use_enable sparc) \
		$(use_enable vorbis oggvorbis) \
		$(use_enable gtk gtk2) \
		$(use_enable systray) \
		--disable-esd \
		--disable-sgi
}

src_install() {
	emake DESTDIR="${D}" install
	einstalldocs
	find "${D}/usr/lib64" -name '*.la' -delete
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}
