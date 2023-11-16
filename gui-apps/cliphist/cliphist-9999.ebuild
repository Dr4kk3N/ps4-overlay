
EAPI=8


DESCRIPTION="Wayland Clipboard Manager"

HOMEPAGE="https://github.com/sentriz/${PN}"

inherit git-r3 go-module
EGIT_REPO_URI="${HOMEPAGE}.git"
EGIT_BRANCH="master"

LICENSE="GPL-3.0"
SLOT="0/9999"

DEPEND="dev-lang/go
		x11-misc/xdg-utils
		gui-apps/wl-clipboard"

BDEPEND=""

src_unpack() {
	git-r3_src_unpack
	go-module_live_vendor
}

src_compile(){
	ego build
}


src_install() {
	dobin ${PN}
}

