# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit qt6-build

DESCRIPTION="Wayland platform plugin for Qt"

if [[ ${QT6_BUILD_TYPE} == release ]]; then
	KEYWORDS="~amd64"
fi

IUSE="vulkan"

BDEPEND="dev-util/wayland-scanner"
DEPEND="
	dev-libs/wayland
	=dev-qt/qtbase-${PV}*[egl,gui,opengl]
	=dev-qt/qtdeclarative-${PV}*
	media-libs/libglvnd
	x11-libs/libxkbcommon
"
RDEPEND="${DEPEND}"

src_configure() {
        local mycmakeargs=(
                $(qt_feature vulkan)
        )

	qt6-build_src_configure
}
