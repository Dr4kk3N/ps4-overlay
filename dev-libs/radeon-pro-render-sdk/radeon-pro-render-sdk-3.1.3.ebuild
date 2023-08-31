EAPI=8

DESCRIPTION="AMD Radeontm ProRender is a powerful physically-based rendering engine"
HOMEPAGE="https://www.amd.com/en/technologies/radeon-prorender"
ICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64"
IUSE="examples"
SRC_URI="https://github.com/GPUOpen-LibrariesAndSDKs/RadeonProRenderSDK/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

# should depend from amd or nvidia drivers + opencl / vulkan
RDEPEND="virtual/opencl
		media-libs/mesa[vulkan]
		=dev-libs/radeon-pro-render-sdk-kernels-9999
		examples? ( sys-devel/gcc[openmp] media-libs/glew )"
DEPEND="${RDEPEND}"
RESTRICT="strip"

S="${WORKDIR}/RadeonProRenderSDK-${PV}"

src_configure() {
	default

	if ! use examples; then 
		return
	fi

	ebegin "Configure tutorials"
		pushd "${S}/tutorials"
			chmod u+x "${S}"/premake5/linux64/premake5
			"${S}"/premake5/linux64/premake5 gmake
		popd
	eend $?
}

src_compile() {
	if ! use examples; then 
		return
	fi

	ebegin "Compile tutorials"
		pushd "${S}/tutorials"
			emake
		popd
	eend $?
}

src_install() {
	local libs+=(
		HybridPro.so
		Hybrid.so
		libNorthstar64.so
		libProRenderGLTF.so
		libRadeonProRender64.so
		libRprLoadStore64.so
		libTahoe64.so
		RprsRender64
	)

	for lib in "${libs[@]}"; do
		dolib.so RadeonProRender/binUbuntu20/${lib}
	done

	dobin RadeonProRender/binUbuntu20/RprTextureCompiler64
	dobin RadeonProRender/binUbuntu20/RprsRender64

	doheader RadeonProRender/inc/*

	insinto "/usr/share/RadeonProRender"
	doins readme.md
	doins license.txt
	doins release_notes.txt

	if use examples; then
		ebegin "Install tutorial resources"
			insinto "/usr/share/RadeonProRender"
			doins -r Resources
		eend $?

		ebegin "Install tutorial sources"
			insinto "/usr/share/RadeonProRender/tutorials"
			for d in $(find "${S}/tutorials/"  -maxdepth 1 -type d  -name '[0-9]*_*'); do
				doins -r "$d"
			done
			doins -r "${S}/tutorials/common"
		eend $?

		ebegin "Remove from tutorial *.dll files"
			rm "${S}"/tutorials/Bin/*.dll
		eend $?
		
		ebegin "Install tutorial compiled binaries"
			exeinto "/usr/share/RadeonProRender/tutorials/Bin"
			for f in $(find "${S}/tutorials/Bin"  -maxdepth 1 -type f  -name '[0-9]*_*'); do
				doexe "$f"
			done
		eend $?

		ebegin "Install tutorial shaders"
			insinto "/usr/share/RadeonProRender/tutorials/Bin"
			for f in $(find "${S}/tutorials/Bin"  -maxdepth 1 -type f  -name '*.fsh' -or -name '*.vsh'); do
				doins "$f"
			done
		eend $?


		ebegin "Install other tutorial files"
			insinto "/usr/share/RadeonProRender/tutorials"

			doins "${S}/tutorials/premake5.lua"
			doins "${S}/tutorials/readme.md"
		eend $?
	fi
}

