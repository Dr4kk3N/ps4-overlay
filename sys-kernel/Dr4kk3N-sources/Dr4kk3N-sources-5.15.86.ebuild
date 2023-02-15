# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

ETYPE="sources"
K_GENPATCHES_VER="90"

# Not supported by the Gentoo security team
K_SECURITY_UNSUPPORTED="1"

inherit kernel-2
detect_version
detect_arch

DESCRIPTION="Linux kernel fork that includes various kernel patches and Gentoo's genpatches"
HOMEPAGE="https://github.com/Dr4kk3N/ps4-linux
	https://dev.gentoo.org/~mpagano/genpatches/"
SRC_URI="SRC_URI="${KERNEL_URI} ${GENPATCHES_URI} ${ARCH_URI}
	https://github.com/Dr4kk3N/ps4-linux/PS4-PV.patch"

IUSE="experimental baikal 2.3Ghz"

K_EXTRAEINFO="This kernel is not supported by Gentoo due to its unstable and
experimental nature."

pkg_setup() {
	ewarn ""
	ewarn "${PN} is *not* supported by the Gentoo Kernel Project in any way."
	ewarn "If you need support, please contact the developers on discord PS4-LINUX or PS4Linux.com."
	ewarn "Do *not* open bugs in Gentoo's bugzilla. Thank you."
	ewarn ""

	kernel-2_pkg_setup
}

pkg_postinst() {
	kernel-2_pkg_postinst
	einfo "For more info on this patchset, and how to report problems, see:"
	einfo "${HOMEPAGE}"
}

pkg_postrm() {
	kernel-2_pkg_postrm
}
