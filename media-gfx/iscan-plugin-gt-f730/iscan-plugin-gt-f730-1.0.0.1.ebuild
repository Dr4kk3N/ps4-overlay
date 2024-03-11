# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit rpm

MY_PV="$(ver_cut 1-3)"
MY_PVR="$(ver_rs 3 -)"
MY_P="esci-interpreter-perfection-v330-${MY_PVR}"

DESCRIPTION="Epson GT-F730, GT-S630, Perfection V33, Perfection V330 Photo scanner plugin for SANE 'epkowa' backend"
HOMEPAGE="http://download.ebz.epson.net/dsc/search/01/search/?OSC=LX"
SRC_URI="amd64? ( https://subnix.mywire.org/distfiles/${MY_P}.x86_64.rpm )
        x86? ( https://subnix.mywire.org/distfiles/${MY_P}.i686.rpm )"
#SRC_URI="amd64? ( https://dev.gentoo.org/~flameeyes/avasys/${MY_P}.x86_64.rpm )
#	x86? ( https://dev.gentoo.org/~flameeyes/avasys/${MY_P}.i386.rpm )"
S="${WORKDIR}"

LICENSE="AVASYS"
SLOT="0"
KEYWORDS="-* amd64 x86"

DEPEND=">=media-gfx/iscan-2.21.0"
RDEPEND="${DEPEND}"

QA_PREBUILT="usr/lib64/esci/libesci-interpreter-perfection-v330.so*"

src_install() {
	local MY_LIB="/usr/$(get_libdir)"

	# install scanner firmware
	insinto /usr/share/esci
	doins "${WORKDIR}/usr/share/esci/"*

	# install scanner plugins
	insinto "${MY_LIB}/esci"
	insopts -m0755
	doins "${WORKDIR}/usr/$(get_libdir)/esci/"*
}

pkg_postinst() {
	local MY_LIB="/usr/$(get_libdir)"

	# Needed for scaner to work properly.
	iscan-registry --add interpreter usb 0x04b8 0x0142 "${MY_LIB}/esci/libesci-interpreter-gt-f730 /usr/share/esci/esfwab.bin" || die
	elog
	elog "Firmware file esfwab.bin for Epson Perfection V330 PHOTO"
	elog "has been installed in ${EROOT}/usr/share/esci and registered for use."
	elog
}

pkg_prerm() {
	local MY_LIB="/usr/$(get_libdir)"

	iscan-registry --remove interpreter usb 0x04b8 0x0142 "${MY_LIB}/esci/libesci-interpreter-gt-f730 /usr/share/esci/esfwab.bin" || die
}
