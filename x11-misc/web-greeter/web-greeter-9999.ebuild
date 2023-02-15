# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

VALA_MIN_API_VERSION="0.34"
VALA_USE_DEPEND="vapigen"

inherit autotools vala

DESCRIPTION="LightDM web-greeter "
HOMEPAGE="https://github.com/Antergos/web-greeter"

if [[ ${PV} == 9999 ]];then
	inherit git-r3
	SRC_URI=""
	KEYWORDS=""
	EGIT_REPO_URI="${HOMEPAGE}"
else
	SRC_URI="${HOMEPAGE}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~x86 ~amd64"
	S="${WORKDIR}/${PN//lightdm-}-${PV}"
fi

LICENSE="GPL-3"
SLOT="0"
IUSE=""

DEPEND="
	$(vala_depend)
	>=x11-misc/lightdm-1.12[introspection,vala]
	>=dev-util/intltool-0.35.0
	sys-devel/gettext
"
RDEPEND="${DEPEND}
	x11-libs/cairo
	media-libs/freetype
	>=x11-libs/gtk+-3.20:3
	media-libs/libcanberra
	x11-libs/libXext
	x11-libs/pixman
"

src_prepare(){
	default_src_prepare
	eautoreconf
}

src_install(){
	default_src_install
	insinto /etc/lightdm
	doins "${FILESDIR}/${PN//lightdm-}.conf"
}

pkg_postinst(){
	einfo "To enable the web-greeter support, set the greeter-session option"
	einfo "to 'web-greeter' in your lightdm.conf in order to get this:"
	einfo "greeter-session=web-greeter"
	einfo "then, restart your session and the lightdm/xdm daemon."
}
