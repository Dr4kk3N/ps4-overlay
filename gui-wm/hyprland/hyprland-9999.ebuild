# Copyright 2023-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake toolchain-funcs

DESCRIPTION="A dynamic tiling Wayland compositor that doesn't sacrifice on its looks"
HOMEPAGE="https://github.com/hyprwm/Hyprland"

if [[ "${PV}" = *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/hyprwm/${PN^}.git"
	HYPRPM_RDEPEND="=dev-libs/hyprland-protocols-9999"
else
	SRC_URI="https://github.com/hyprwm/${PN^}/releases/download/v${PV}/source-v${PV}.tar.gz -> ${P}.gh.tar.gz"
	S="${WORKDIR}/${PN}-source"

	KEYWORDS="~amd64"
fi

LICENSE="BSD"
SLOT="0"
IUSE="X legacy-renderer systemd"

# hyprpm (hyprland plugin manager) requires the dependencies at runtime
# so that it can clone, compile and install plugins.
HYPRPM_RDEPEND="
	${HYPRPM_RDEPEND}
	app-alternatives/ninja
	dev-build/cmake
	dev-libs/libliftoff
	dev-vcs/git
	virtual/pkgconfig
"

RDEPEND="
	${HYPRPM_RDEPEND}
	dev-cpp/tomlplusplus
	dev-libs/glib:2
	dev-libs/libinput
	>=dev-libs/wayland-1.20.0
	>=gui-libs/hyprcursor-0.1.7
	media-libs/libglvnd
	x11-libs/cairo
	x11-libs/libdrm
	x11-libs/libxkbcommon
	x11-libs/pango
	x11-libs/pixman
	X? (
		x11-libs/libxcb:0=
	)
"
DEPEND="
	${RDEPEND}
	>=dev-libs/hyprland-protocols-0.2
	>=dev-libs/hyprlang-0.3.2
	>=dev-libs/wayland-protocols-1.34
"
BDEPEND="
	>=sys-devel/gcc-13:*
	>=sys-devel/clang-16:*
	app-misc/jq
	dev-build/cmake
	dev-util/hyprwayland-scanner
	virtual/pkgconfig
"

pkg_setup() {
	[[ ${MERGE_TYPE} == binary ]] && return

	if tc-is-gcc && ver_test $(gcc-version) -lt 13 ; then
		eerror "Hyprland requires >=sys-devel/gcc-13 to build"
		eerror "Please upgrade GCC: emerge -v1 sys-devel/gcc"
		die "GCC version is too old to compile Hyprland!"
	elif tc-is-clang && ver_test $(clang-version) -lt 16 ; then
		eerror "Hyprland requires >=sys-devel/clang-16 to build"
		eerror "Please upgrade Clang: emerge -v1 sys-devel/clang"
		die "Clang version is too old to compile Hyprland!"
	fi
}

src_prepare() {
	default

	# Don't create symlinks.
        sed -i -e '353,359d' CMakeLists.txt || die

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DLEGACY_RENDERER=$(usex legacy-renderer '1' '0')
		-DNO_SYSTEMD=$(usex systemd '0' '1')
		-DNO_XWAYLAND=$(usex X '0' '1')
	)

	cmake_src_configure
}

src_install() {
	cmake_src_install
}
