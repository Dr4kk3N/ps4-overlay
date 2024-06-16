# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson git-r3

DESCRIPTION="Dynamic, cross-platform, and embeddable LaTeX rendering library."
HOMEPAGE="https://github.com/NanoMichael/MicroTeX"

EGIT_REPO_URI="https://github.com/NanoMichael/MicroTeX.git"

LICENSE="LGPL 2.1"
SLOT="0"

IUSE="X debug"

RDEPEND="
	X? (
		>=x11-libs/libX11-1.6.2
		>=x11-libs/libxshmfence-1.1
		>=x11-libs/libXext-1.3.2
		>=x11-libs/libXxf86vm-1.1.3
		>=x11-libs/libxcb-1.13
	)
"

multilib_src_configure() {
	local emesonargs=()
	emesonargs+=(
		--buildtype $(usex debug debug plain)
		-Db_ndebug=$(usex debug false true)
	)
	meson_src_configure
}
