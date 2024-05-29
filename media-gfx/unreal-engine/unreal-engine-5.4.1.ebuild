
EAPI=8

LLVM_COMPAT=( 16 17 )

inherit xdg pax-utils check-reqs readme.gentoo-r1 linux-info llvm-r1

# Package is 3 Gib smaller with "strip" but it's skipped because it takes a long time and generates many warnings
# RESTRICT="fetch strip staticlibs network-sandbox"
RESTRICT="strip staticlibs network-sandbox"

DESCRIPTION="A 3D game engine by Epic Games which can be used non-commercially for free."
HOMEPAGE="https://www.unrealengine.com/"
RELEASE="${PV}-release"
TOOLCHAIN_VERSION=v22_clang-16.0.6-centos7

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/EpicGames/UnrealEngine.git"
else
	SRC_URI="${RELEASE}.tar.gz
        https://github.com/EpicGames/UnrealEngine/archive/refs/tags/${PV}-release.tar.gz -> ${TOOLCHAIN_VERSION}.tar.gz"
	KEYWORDS="-* ~amd64"
fi

LICENSE="UnrealEngine"
SLOT="0"
IUSE="+X wayland +clang lto pgo debug"
REQUIRED_USE="|| ( X wayland )
	pgo? ( lto )"

BDEPEND="$(llvm_gen_dep '
		sys-devel/clang:${LLVM_SLOT}
		sys-devel/llvm:${LLVM_SLOT}
		clang? (
			sys-devel/lld:${LLVM_SLOT}
			virtual/rust:0/llvm-${LLVM_SLOT}
		)
		pgo? ( sys-libs/compiler-rt-sanitizers:${LLVM_SLOT}[profile] )
	')
	>=dev-lang/mono-5.20.1.19
	app-text/dos2unix
	dev-util/cmake
	dev-vcs/git
	pgo? (
		X? (
			sys-devel/gettext
			x11-base/xorg-server[xvfb]
			x11-apps/xhost
		)
		!X? (
			>=gui-libs/wlroots-0.15.1-r1[tinywl]
			x11-misc/xkeyboard-config
		)
	)
	X? (
		virtual/opengl
		x11-libs/libX11
		x11-libs/libXcomposite
		x11-libs/libXdamage
		x11-libs/libXext
		x11-libs/libXfixes
		x11-libs/libxkbcommon[X]
		x11-libs/libXrandr
		x11-libs/libXtst
		x11-libs/libxcb:=
	)"

RDEPEND="${DEPEND}
	dev-libs/icu
	media-libs/libsdl2
	dev-lang/python
	>=sys-devel/lld-16.0.6
	x11-misc/xdg-user-dirs
	x11-terms/xterm"

DEPEND="${BDEPEND}
	X? (
		x11-base/xorg-proto
		x11-libs/libICE
		x11-libs/libSM
	)"

PATCHES=(
	"${FILESDIR}/ignore-clang-install.patch"
	"${FILESDIR}/use-system-mono.patch"
	"${FILESDIR}/recompile-version-selector.patch"
	"${FILESDIR}/llvm17.patch"
	"${FILESDIR}/1920-default.patch"
)

S="${WORKDIR}/${RELEASE}"

llvm_check_deps() {
	if ! has_version -b "sys-devel/clang:${LLVM_SLOT}" ; then
		einfo "sys-devel/clang:${LLVM_SLOT} is missing! Cannot use LLVM slot ${LLVM_SLOT} ..." >&2
		return 1
	fi

	if use clang && ! tc-ld-is-mold ; then
		if ! has_version -b "sys-devel/lld:${LLVM_SLOT}" ; then
			einfo "sys-devel/lld:${LLVM_SLOT} is missing! Cannot use LLVM slot ${LLVM_SLOT} ..." >&2
			return 1
		fi

		if ! has_version -b "virtual/rust:0/llvm-${LLVM_SLOT}" ; then
			einfo "virtual/rust:0/llvm-${LLVM_SLOT} is missing! Cannot use LLVM slot ${LLVM_SLOT} ..." >&2
			return 1
		fi

		if use pgo ; then
			if ! has_version -b "=sys-libs/compiler-rt-sanitizers-${LLVM_SLOT}*[profile]" ; then
				einfo "=sys-libs/compiler-rt-sanitizers-${LLVM_SLOT}*[profile] is missing! Cannot use LLVM slot ${LLVM_SLOT} ..." >&2
				return 1
			fi
		fi
	fi

	einfo "Using LLVM slot ${LLVM_SLOT} to build" >&2
}

pkg_nofetch() {
	einfo "Please download ${A} from:"
	einfo "  ${HOMEPAGE}"
	einfo "The archive should then be placed into your DISTDIR directory."
}

pkg_pretend() {
	if [[ ${MERGE_TYPE} != binary ]] ; then
		if use pgo ; then
			if ! has usersandbox $FEATURES ; then
				die "You must enable usersandbox as X server can not run as root!"
			fi
		fi

		# Ensure we have enough disk space to compile
		if use pgo || use lto || use debug ; then
			CHECKREQS_DISK_BUILD="100000M"
		else
			CHECKREQS_DISK_BUILD="10000M"
		fi

		check-reqs_pkg_pretend
	fi
}

src_unpack() {
	unpack ${RELEASE}.tar.gz
	local TOOLCHAIN_ROOT="Engine/Extras/ThirdPartyNotUE/SDKs/HostLinux/Linux_x64/"
	mkdir -p "${S}/${TOOLCHAIN_ROOT}" || die
	pushd "${S}/${TOOLCHAIN_ROOT}" || die
	unpack ${TOOLCHAIN_VERSION}.tar.gz
	popd || die
}

src_prepare() {
	default
	export TERM=xterm

	echo "Copy cache"
	cp -r /usr/portage/distfiles/${RELEASE} ${WORKDIR}

	cp ${FILESDIR}/UE5Editor.desktop UE5Editor.desktop || die
	sed -i "5c\Path=/opt/${PN}/Engine/Binaries/Linux/" UE5Editor.desktop || die
	sed -i "6c\Exec=\'/opt/${PN}/Engine/Binaries/Linux/UE5Editor\' %F" UE5Editor.desktop || die
	cp "${FILESDIR}/Makefile" Makefile
	sed -i -e "s|http://cdn.unrealengine.com/dependencies|https://cdn.unrealengine.com/dependencies|g" Engine/Build/Commit.gitdeps.xml || die
	sed -i -e "s|http://cdn.unrealengine.com/dependencies|https://cdn.unrealengine.com/dependencies|g" Engine/Source/Programs/GitDependencies/DependencyManifest.cs || die

	addpredict /etc/mono/registry
	for event in /dev/input/event* ; do
		addpredict "${event}"
	done
	pax-mark m Engine/Extras/GDBPrinters/UE5Printers.py

	echo "Running setup"
	./Setup.sh

	echo "generating project files"
	./GenerateProjectFiles.sh -makefile

	cp Engine/Source/Programs/UnrealVS/Resources/Preview.png UE5Editor.png || die
}

src_compile() {
	emake -j1
	sed -ri 's|(..*)-makefile.*|\1-projectfiles "$@"|' Engine/Build/BatchFiles/Linux/GenerateProjectFiles.sh || die
	sed -ri '/(..*)make.*/,+1d' Setup.sh || die
}

src_install() {
	local dir=/opt/${PN}
	insinto /usr/share/applications
	doins UE5Editor.desktop
	insinto /usr/share/licenses/UnrealEngine
	doins LICENSE.md
	# fperms a+x Engine/Binaries/DotNET/IOS/IPhonePackager.exe
	insinto /usr/share/pixmaps
	doins UE5Editor.png
	dodir ${dir}/Engine
	dodir ${dir}/Engine/DerivedDataCache # editor needs this
	dodir ${dir}/Engine/Intermediate # editor needs this, but not the contents
	dodir ${dir}/Engine/Source # the source cannot be redistributed, but seems to be needed to compile c++ projects
	insinto ${dir}/Engine
	doins -r Engine/Binaries
	doins -r Engine/Build
	doins -r Engine/Config
	doins -r Engine/Content
	doins -r Engine/Documentation
	doins -r Engine/Extras
	doins -r Engine/Plugins
	doins -r Engine/Programs
	doins -r Engine/Saved
	doins -r Engine/Shaders
	# these folders needs to be writable, otherwise there is a segmentation fault when starting the editor
	# fperms -R a+rwX ${dir}/Engine
	insinto ${dir}
	# content
	doins -r FeaturePacks
	doins -r Samples
	doins -r Templates
	# build scripts, used by some plugins (CLion)
	doins GenerateProjectFiles.sh Setup.sh
	doins .ue5dependencies
}
