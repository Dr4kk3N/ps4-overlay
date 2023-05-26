# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake multibuild xdg

DESCRIPTION="BitTorrent client in C++ and Qt"
HOMEPAGE="https://www.qbittorrent.org
	  https://github.com/qbittorrent"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/${PN}/qBittorrent.git"
else
	SRC_URI="https://github.com/qbittorrent/qBittorrent/archive/release-${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"
	S="${WORKDIR}/qBittorrent-release-${PV}"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="+dbus +gui test webui"
RESTRICT="!test? ( test )"
REQUIRED_USE="dbus? ( gui )
	|| ( gui webui )"

RDEPEND="
	>=dev-libs/boost-1.65.0-r1:=
	dev-libs/openssl:=
	dev-qt/qtbase:6[network,sql,xml]
	>=net-libs/libtorrent-rasterbar-1.2.14:=
	sys-libs/zlib
	dbus? ( dev-qt/qtbase:6[dbus] )
	gui? (
		dev-libs/geoip
		dev-qt/qtbase:6[gui]
		dev-qt/qtsvg:6
		dev-qt/qtbase:6[widgets]
	)"
DEPEND="${RDEPEND}"
BDEPEND="dev-qt/qttools:6[linguist]
	virtual/pkgconfig"

DOCS=( AUTHORS Changelog CONTRIBUTING.md README.md )

src_prepare() {
	sed -i "s/QBT_VERSION_MINOR 6/QBT_VERSION_MINOR 5/g" src/base/version.h.in
#	sed -i "s/QBT_VERSION_BUGFIX 0/QBT_VERSION_BUGFIX 5/g" src/base/version.h.in
	sed -i "s/alpha1//g" src/base/version.h.in
	sed -i "s/beta1//g" src/base/version.h.in

	MULTIBUILD_VARIANTS=()
	use gui && MULTIBUILD_VARIANTS+=( gui )
	use webui && MULTIBUILD_VARIANTS+=( nogui )

	cmake_src_prepare
}

src_configure() {
	multibuild_src_configure() {
		local mycmakeargs=(
			# musl lacks execinfo.h
			-DSTACKTRACE=OFF

			# We always want to install unit files
			-DSYSTEMD=OFF

			# More verbose build logs are preferable for bug reports
			-DVERBOSE_CONFIGURE=OFF

			-DQT6=ON

			# We do these in multibuild, see bug #839531 for why.
			# Fedora has to do the same thing.
			-DWEBUI=$(usex webui)

			-DCMAKE_BUILD_TYPE=Release

			-DTESTING=$(usex test)
		)

		if [[ ${MULTIBUILD_VARIANT} == gui ]] ; then
			# We do this in multibuild, see bug #839531 for why.
			# Fedora has to do the same thing.
			mycmakeargs+=(
				-DGUI=ON
				-DDBUS=$(usex dbus)
				-DSYSTEMD=OFF
			)
		else
			mycmakeargs+=(
				-DGUI=OFF
				-DDBUS=OFF
				# The systemd service calls qbittorrent-nox, which is only
				# installed when GUI=OFF.
				-DSYSTEMD=OFF
			)
		fi

		cmake_src_configure
	}

	multibuild_foreach_variant multibuild_src_configure
}

src_compile() {
	multibuild_foreach_variant cmake_src_compile
}

src_install() {
	multibuild_foreach_variant cmake_src_install
	einstalldocs
}
