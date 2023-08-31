EAPI=8

inherit git-r3

DESCRIPTION="AMD Radeon Pro Render precompiled kernels"
HOMEPAGE="https://www.amd.com/en/technologies/radeon-prorender"
ICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64"
IUSE=""
#SRC_URI="https://github.com/GPUOpen-LibrariesAndSDKs/RadeonProRenderSDK/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
# Core release version is 3.1.00 . Last 00 is bad number, temporary hardcode archive name
SRC_URI="https://github.com/GPUOpen-LibrariesAndSDKs/RadeonProRenderSDK/archive/refs/tags/v3.1.00.patch2.tar.gz -> ${P}.tar.gz"

# should depend from amd or nvidia drivers + opencl
RDEPEND=""
DEPEND="${RDEPEND}"
RESTRICT="strip"

EGIT_REPO_URI="https://github.com/GPUOpen-LibrariesAndSDKs/RadeonProRenderSDKKernels.git"
EGIT_BRANCH="main"
S="${WORKDIR}/${PF}"

src_install() {
	insinto "/usr/share/RadeonProRender/hipbin"
	for f in "${S}"/*; do
		doins "$f"
	done
}

