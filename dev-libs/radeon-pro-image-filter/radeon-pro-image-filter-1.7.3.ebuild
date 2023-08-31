EAPI=8

inherit cmake

DESCRIPTION="AMD Radeon Image Filter SDK"
HOMEPAGE="https://www.amd.com/en/technologies/radeon-prorender"
ICENSE="Apache-2.0"
SLOT="0/${PV}"
KEYWORDS="amd64"
IUSE="examples"
SRC_URI="https://github.com/GPUOpen-LibrariesAndSDKs/RadeonImageFilter/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

# should depend from amd or nvidia drivers + opencl
RDEPEND="virtual/opencl
		>=dev-libs/opencl-icd-loader-2021.06.30
		examples? ( sys-devel/gcc[openmp] )"
DEPEND="${RDEPEND} app-admin/chrpath"
RESTRICT="strip"

S="${WORKDIR}/RadeonImageFilter-${PV}"
CMAKE_USE_DIR=${S}/samples

src_configure() {

	if ! use examples; then 
		return
	fi

	local mycmakeargs=(
		-DCMAKE_SKIP_BUILD_RPATH=on
	)

	cmake_src_configure
}

src_compile() {
	if ! use examples; then 
		return
	fi

	local cmake_args=(CMAKE_SKIP_INSTALL_RPATH TRUE)
	cmake_src_compile
}

src_install() {
	local libs+=(
		libMIOpen.so.2.0.5
		libOpenImageDenoise.so.0.9.0
		libRadeonImageFilters.so.1.7.3
		libRadeonML_MIOpen.so.0.9.12
		libRadeonML.so.0.9.12
	)

	# security fix - remove hardcoded rpath from library
	chrpath -d "${S}/Ubuntu20/Dynamic/libOpenImageDenoise.so.0.9.0"

	for lib in "${libs[@]}"; do
		dolib.so Ubuntu20/Dynamic/${lib}
	done

	local symlinks+=(
		libMIOpen.so.2
		libOpenImageDenoise.so.0
		libRadeonImageFilters.so.1
		libRadeonML_MIOpen.so.0
		libRadeonML.so.0
		libMIOpen.so
		libOpenImageDenoise.so
		libRadeonImageFilters.so
		libRadeonML_MIOpen.so
		libRadeonML.so
	)
	for symlink in "${symlinks[@]}"; do
		dolib.so Ubuntu20/Dynamic/${symlink}
	done

	doheader include/*

	insinto "/usr/share/RadeonImageFilter"
	doins README.md
	doins License.md
	doins RELEASENOTES1.7.3.md
	doins -r models

	if use examples; then
		ebegin "Install tutorial sources"
			insinto "/usr/share/RadeonImageFilter"
			doins -r samples
		eend $?

		ebegin "Install tutorial compiled binaries"
			exeinto "/usr/share/RadeonImageFilter/samples/Bin"

			for f in $(find "${BUILD_DIR}" -maxdepth 2 -type f -executable); do
				local fname=$(basename $f)
				exeinto "/usr/share/RadeonImageFilter/samples/Bin/$fname"
				doexe "$f"
			done
		eend $?
	fi
}


