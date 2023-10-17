# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="CPU-X"

inherit cmake gnome2-utils xdg

DESCRIPTION="A Free software that gathers information on CPU, motherboard and more"
HOMEPAGE="https://thetumultuousunicornofdarkness.github.io/CPU-X/"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/TheTumultuousUnicornOfDarkness/${MY_PN}.git"
else
	SRC_URI="https://github.com/TheTumultuousUnicornOfDarkness/${MY_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="-* ~amd64"
	S="${WORKDIR}/${MY_PN}-${PV}"
fi

LICENSE="GPL-3+"
SLOT="0"
IUSE="+bandwidth +dmidecode force-libstatgrab +gui +libcpuid +libglfw +ncurses +nls opencl +pci test +vulkan"
RESTRICT="!test? ( test )"

COMMON_DEPEND="
	dev-libs/glib:2
	x11-libs/cairo
	x11-libs/gdk-pixbuf:2
	x11-libs/pango
	force-libstatgrab? ( sys-libs/libstatgrab )
	!force-libstatgrab? ( sys-process/procps:= )
	gui? ( >=x11-libs/gtk+-3.12:3 )
	libcpuid? ( >=dev-libs/libcpuid-0.6.0:= )

	libglfw? (
		>=media-libs/glfw-3.3
		virtual/opengl
	)

	ncurses? ( sys-libs/ncurses:=[tinfo] )
	opencl? ( virtual/opencl )
	pci? ( sys-apps/pciutils )
	vulkan? ( media-libs/vulkan-loader )
"

DEPEND="
	test? (
		sys-apps/mawk
		sys-apps/nawk
	)

	${COMMON_DEPEND}
"

BDEPEND="
	dev-lang/nasm
	virtual/pkgconfig
	nls? ( sys-devel/gettext )
"

RDEPEND="${COMMON_DEPEND}"

DOCS=(
	CONTRIBUTING.md
	ChangeLog.md
	README.md
)

src_configure() {
	local mycmakeargs=(
		-DFORCE_LIBSTATGRAB=$(usex force-libstatgrab)
		-DGSETTINGS_COMPILE=OFF
		-DWITH_BANDWIDTH=$(usex bandwidth)
		-DWITH_DMIDECODE=$(usex dmidecode)
		-DWITH_GETTEXT=$(usex nls)
		-DWITH_GTK=$(usex gui)
		-DWITH_LIBCPUID=$(usex libcpuid)
		-DWITH_LIBGLFW=$(usex libglfw)
		-DWITH_LIBPCI=$(usex pci)
		-DWITH_LIBSTATGRAB=OFF
		-DWITH_NCURSES=$(usex ncurses)
		-DWITH_OPENCL=$(usex opencl)
		-DWITH_VULKAN=$(usex vulkan)
	)

	cmake_src_configure
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update
}

pkg_postrm() {
	xdg_pkg_postinst
	gnome2_schemas_update
}
