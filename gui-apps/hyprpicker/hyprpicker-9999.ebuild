# Copyright 2022 Aisha Tammy <floss@bsd.ac>
# Distributed under the terms of the ISC License

EAPI=8

inherit cmake

DESCRIPTION="A wlroots-compatible Wayland color picker that does not suck."
HOMEPAGE="https://github.com/hyprwm/Hyprpicker"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/hyprwm/hyprpicker/"
else
	COMMIT="cc6b3234b2966acd61c8a2e5caae947774666601"
	SRC_URI="https://github.com/hyprwm/hyprpicker/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/hyprpicker-${COMMIT}"
	KEYWORDS="~amd64"
fi

LICENSE="BSD"
SLOT="0"

DEPEND="
	dev-libs/wayland
	media-libs/libglvnd
"
RDEPEND="${DEPEND}"
BDEPEND="
	dev-libs/wayland-protocols
	virtual/pkgconfig
"

src_compile() {
	emake protocols
	cmake_src_compile
}

src_install() {
	dobin "${BUILD_DIR}/hyprpicker"
}
