# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="A quick-n-dirty BSD licensed clone of the GNU libc backtrace facility"
HOMEPAGE="https://www.freshports.org/devel/libexecinfo"
SRC_URI="http://distcache.freebsd.org/local-distfiles/itetcu/${P}.tar.bz2"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="static-libs"

PATCHES=(
	"${FILESDIR}/10-execinfo.patch"
	"${FILESDIR}/20-define-gnu-source.patch"
	"${FILESDIR}/30-linux-makefile.patch"
)

_warning_message() {
	ewarn "This package will be removed on 2023-01-01."
	ewarn "This package can cause weird issues on some other packages."
	ewarn ""
	ewarn "If your builds are failing because of execinfo.h, try and patch it out"
	ewarn "instead of using this package."
	ewarn "libexecinfo was recently removed from alpine repos (2022-07-31) so more"
	ewarn "patches should be available for software failing to compile on musl"
	ewarn ""
	ewarn "If you still intend to use this package, copy it a local repo."
}

pkg_pretend() {
	_warning_message
}

src_prepare() {
	default

	sed -i -e 's/CC=/CC?=/' \
		-e 's/AR=/AR?=/' \
		-e 's/-O2//' \
		Makefile || die
}

src_install() {
	einstalldocs

	doheader execinfo.h
	doheader stacktraverse.h
	use static-libs && dolib.a libexecinfo.a
	dolib.so libexecinfo.so.1
	dosym ./libexecinfo.so.1 /usr/"$(get_libdir)"/libexecinfo.so
}

pkg_postinst() {
	_warning_message
}
