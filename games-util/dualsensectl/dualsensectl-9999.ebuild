# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit udev xdg linux-info

DESCRIPTION="Linux tool for controlling Sony PlayStation 5 DualSense controller."
HOMEPAGE="https://github.com/nowrep/dualsensectl"

if [[ "${PV}" == *9999* ]] ; then
        inherit git-r3

        EGIT_REPO_URI="https://github.com/nowrep/${PN}.git"
else
        SRC_URI="https://github.com/nowrep/${PN}/archive/${PV}.tar.gz
                -> ${P}.tar.gz"

        KEYWORDS="amd64 ~x86"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="+acl elogind systemd doc"
REQUIRED_USE="acl? ( || ( elogind systemd ) )"
RESTRICT="test"

RDEPEND="
        media-libs/libsdl2[X,joystick]
        virtual/udev
        x11-libs/libX11
        x11-libs/libXi
        x11-libs/libXtst
	acl? (
		elogind? ( sys-auth/elogind[acl] )
		systemd? ( sys-apps/systemd[acl] )
	)
	!acl? (
		acct-group/input
	)
	virtual/udev
"

DOCS=( README.md )

pkg_setup() {
	CONFIG_CHECK="~HIDRAW"
	linux-info_pkg_setup

	if ! use acl; then
		elog "Users of game hardware devices must be added to the input group."

		if use elogind || use systemd; then
			ewarn "It is highly recommended that you enable USE=acl on this package instead"
			ewarn "when using elogind or systemd as this is more secure and just works."
		fi
	fi
}

#src_prepare() {
#	einfo "Applying patch for README file"
#	eapply -p1 "${FILESDIR}/installation.patch"
#	eapply_user
#	eautoreconf
#}

#src_configure() {
#
#}

src_install() {
	default
#	udev_dorules 70-dualsensectl-{input}.rules
#	insinto /usr/share/completion
#        doins -r completion
}

pkg_postinst() {
	udev_reload
}

pkg_postrm() {
	udev_reload
}
