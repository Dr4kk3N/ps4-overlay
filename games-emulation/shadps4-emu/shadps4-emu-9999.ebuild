# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

QTMIN=6.7.1
LLVM_COMPAT=( {17..18} )
LLVM_OPTIONAL=1

inherit cmake desktop xdg fcaps flag-o-matic llvm-r1 toolchain-funcs

DESCRIPTION="PlayStation 4 emulator"
HOMEPAGE="https://github.com/shadps4-emu/shadPS4"

if [[ ${PV} == *9999 ]]
then
	EGIT_REPO_URI="https://github.com/shadps4-emu/shadPS4.git"
	EGIT_SUBMODULES=( 'externals/boost' \
			  'externals/cryptopp' \
			  'externals/cryptopp-cmake' \
			  'externals/cryptoppwin' \
			  'externals/discord-rpc' \
			  'externals/fmt' \
			  'externals/glslang' \
			  'externals/magic_enum' \
			  'externals/robin-map' \
			  'externals/sdl3' \
			  'externals/sirit' \
			  'externals/toml11' \
			  'externals/tracy' \
			  'externals/wma' \
			  'externals/vulkan-headers' \
			  'externals/winpthread' \
			  'externals/xbyak' \
			  'externals/xxhash' \
			  'externals/zlib-ng' \
			  'externals/zydis' \
			  'externals/zydis/dependencies/zycore' \
			  'externals/sirit/externals/SPIRV-Headers'
			)
	inherit git-r3
else
	EGIT_COMMIT=86911747bf64324cfd438afc08f6f6a0a9f7ff41
	ZYDIS_COMMIT=5a68f639e4f01604cc7bfc8d313f583a8137e3d3
	SRC_URI="
		https://github.com/shadps4-emu/shadPS4/archive/${EGIT_COMMIT}.tar.gz
			-> ${P}.tar.gz
		https://github.com/zyantific/zydis/archive/${ZYDIS_COMMIT}.tar.gz
		mgba? (
			https://github.com/mgba-emu/mgba/archive/${MGBA_COMMIT}.tar.gz
				-> mgba-${MGBA_COMMIT}.tar.gz
		)
	"
	S=${WORKDIR}/${PN}-${EGIT_COMMIT}
	KEYWORDS="~amd64 ~arm64"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="+llvm alsa discord pulseaudio sndio vulkan wayland test debug"
RESTRICT="!test? ( test )"
REQUIRED_USE="
	llvm? ( ${LLVM_REQUIRED_USE} )
"

COMMON_DEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[concurrent,widgets]
	app-arch/lz4:=
	app-arch/xz-utils
	app-arch/zstd:=
	dev-libs/libaio
	app-text/doxygen
	media-libs/libglvnd
	media-libs/libpng:=
	media-libs/libsdl2[haptic,joystick]
	media-libs/libwebp:=
	media-video/ffmpeg:=
	net-libs/libpcap
	net-misc/curl
	sys-apps/dbus
	sys-libs/zlib:=
	virtual/libudev:=
	x11-libs/libXrandr
	alsa? ( media-libs/alsa-lib )
	pulseaudio? ( media-libs/libpulse )
	sndio? ( media-sound/sndio:= )
	vulkan? ( media-libs/vulkan-loader )
	wayland? ( dev-libs/wayland )
"
RDEPEND="
	${COMMON_DEPEND}
"
DEPEND="
	${COMMON_DEPEND}
	x11-base/xorg-proto
"
BDEPEND="
	dev-qt/qttools:6[linguist]
	sys-devel/clang:*
	wayland? (
		dev-util/wayland-scanner
		kde-frameworks/extra-cmake-modules
	)
"

#PATCHES=(
#	"${FILESDIR}"/${PN}-typo.patch
#)

pkg_setup() {
	if use llvm && has_version sys-devel/llvm[!debug=]; then
		ewarn "Mismatch between debug USE flags in games-emulation/shadps4 and sys-devel/llvm"
		ewarn "detected! This can cause problems."
	fi

	use llvm && llvm-r1_pkg_setup
}

src_prepare() {
	default
#	sed -i -e "/^PLATFORM_SYMBOLS/a '__gentoo_check_ldflags__'," bin/symbols-check.py || die
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=OFF # to remove after unbundling
		-DSDL_SHARED=ON
		-DUSE_LINKED_FFMPEG=yes
		-DENABLE_QT_GUI=yes
		-DUSE_VULKAN=$(usex vulkan)
		-DWAYLAND_API=$(usex wayland)
		-DCHECK_ALSA=$(usex alsa)
		-DCHECK_PULSE=$(usex pulseaudio)
		-DCHECK_SNDIO=$(usex sndio)
	)
	cmake_src_configure
}

src_install() {

	domenu "${FILESDIR}"/shadps4.desktop
	doicon -s 128 "${FILESDIR}"/shadps4.png
	#doicon -s 48 images/shadps4.ico

	#insinto /usr/lib/${PN}
	# doins -r "${BUILD_DIR}"/bin/.
	#fperms +x /usr/lib/${PN}/shadps4

	exeinto "/opt/shadps4"

	insinto /opt/shadps4
        doins -r "${BUILD_DIR}"/.
        fperms +x /opt/shadps4/shadps4
	insopts -m0755
	dosym "/opt/shadps4/${PN}" "/usr/bin/${PN}"

	use !test || rm "${ED}"/opt/${PN}/*_test || die
}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
