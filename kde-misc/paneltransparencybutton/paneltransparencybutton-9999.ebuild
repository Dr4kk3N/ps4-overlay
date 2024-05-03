# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

EGIT_REPO_URI="https://github.com/psifidotos/${PN}.git"

inherit ecm git-r3

DESCRIPTION="Enable/disable transparency for specific plasma panels"
HOMEPAGE="https://github.com/TheEssem/paneltransparencybutton"
SRC_URI=""

LICENSE="GPL-2"
SLOT="6"
KEYWORDS=""

RDEPEND="kde-plasma/plasma-workspace:6"

DOCS=( {CHANGELOG,README}.md )

src_prepare() {
	default
}

src_configure() { :; }

src_compile() { :; }

src_install() {
	default

	insinto /usr/share/plasma/plasmoids/org.kde.latte.unity
	doins metadata.desktop
	doins -r contents
}
