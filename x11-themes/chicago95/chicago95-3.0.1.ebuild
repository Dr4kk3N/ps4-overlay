# Copyright 2021 Bryan Gardiner <bog@khumba.net>
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit font xdg

REPO_NAME="Chicago95"

DESCRIPTION="Linux rendition of everyone's favourite 1995 Microsoft OS"
HOMEPAGE="https://github.com/grassmunk/${REPO_NAME}"
SRC_URI="https://github.com/grassmunk/${REPO_NAME}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+ MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gtk login-sound plymouth +sound"

DEPEND=""
RDEPEND="
	gtk? ( x11-libs/gtk+:* )
	login-sound? ( media-sound/sox )
	plymouth? ( sys-boot/plymouth )
"

S="${WORKDIR}/${REPO_NAME}-${PV}"

src_install() {
	einfo "Cleaning up src directories."
	find "${D}" -type d -name src -exec rm -rv '{}' +

	# Parallel install does not work.  Also this ebuild doesn't install
	# the 'plus' GUI for converting Windows themes.
	emake -j1 DESTDIR="${D}" DOCDIR="${ED}/usr/share/doc/${PF}" \
		install_cursors \
		install_doc \
		install_fonts \
		$(usex gtk install_gtk_theme "") \
		install_icons \
		$(usex sound install_sounds "") \
		$(usex login-sound install_login_sound "") \
		$(usex plymouth install_boot_screen "")
}

pkg_postinst() {
	font_pkg_postinst
	xdg_pkg_postinst
}

pkg_postrm() {
	font_pkg_postrm
	xdg_pkg_postrm
}
