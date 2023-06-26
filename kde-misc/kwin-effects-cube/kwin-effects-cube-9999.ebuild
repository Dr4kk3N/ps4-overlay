# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Desktop cube effect for Kwin."
HOMEPAGE="https://github.com/zzag/kwin-effects-cube"

if [[ ${PV} == 9999 ]]; then
        EGIT_REPO_URI="https://github.com/zzag/kwin-effects-cube"
        inherit git-r3
else
        SRC_URI="https://github.com/zzag/${PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
fi

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="dev-qt/qtcore:6
	dev-qt/qtdbus:6
	dev-qt/qtgui:6
	dev-qt/qtquick3d:6
	dev-qt/qtquickcontrols2:6
	kde-frameworks/kconfig:6
	kde-frameworks/kconfigwidgets:6
	kde-frameworks/kcoreaddons:6
	kde-frameworks/kglobalaccel:6
	kde-frameworks/ki18n:6
	kde-frameworks/kwindowsystem:6
	kde-frameworks/kxmlgui:6
	media-libs/libepoxy
	kde-plasma/kwin
	x11-libs/libxcb"
RDEPEND="${DEPEND}"
BDEPEND="dev-util/cmake
	kde-frameworks/extra-cmake-modules"

src_prepare() {
	sed -re 's/kwin4/kwin/g' -i src/CMakeLists.txt || die
	cmake_src_prepare
}

pkg_postinst() {
	einfo
	einfo 'You will likely need to restart Kwin for this option to display. Perform the following'
	einfo 'in a new terminal or reboot your system:'
	einfo
	einfo '  kwin_x11 --replace &'
	einfo
}
