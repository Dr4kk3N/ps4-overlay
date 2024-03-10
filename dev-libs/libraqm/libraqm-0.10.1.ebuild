# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/HOST-Oman/${PN}.git"
else
	SRC_URI="https://github.com/HOST-Oman/${PN}/releases/download/v${PV}/raqm-${PV}.tar.xz -> libraqm-${PV}.tar.xz"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/raqm-${PV}"
fi
inherit meson

DESCRIPTION="A library for complex text layout"
HOMEPAGE="https://github.com/HOST-Oman/${PN}"

LICENSE="MIT"
SLOT="0"
IUSE="gtk-doc"

RDEPEND="
	media-libs/freetype:2
	media-libs/harfbuzz:=
	dev-libs/fribidi
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	gtk-doc? ( dev-util/gtk-doc )
"

src_configure() {
	local emesonargs=(
		$(meson_use gtk-doc docs)
	)
	meson_src_configure
}
