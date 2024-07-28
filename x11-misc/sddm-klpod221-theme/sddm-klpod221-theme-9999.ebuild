# Copyright 2019-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="SDDM theme"
HOMEPAGE="https://github.com/klpod221/sddm-klpod221-theme"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/klpod221/sddm-klpod221-theme.git"
else
	COMMIT=1a8a5ba00aa4a98fcdc99c9c1547d73a2a64c1bf
	SRC_URI="https://github.com/klpod221/sddm-klpod221-theme/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${PN}-${COMMIT}"
fi

QTMIN=6.7.1
LICENSE="GPL-2"
SLOT="0"

RDEPEND="
	acct-group/sddm
	acct-user/sddm
	x11-misc/sddm
	>=dev-qt/qtbase-${QTMIN}:6[dbus,gui]
	>=dev-qt/qtdeclarative-${QTMIN}:6
	>=dev-qt/qtsvg-${QTMIN}:6
	>=dev-qt/qt5compat-${QTMIN}:6
"

src_install() {
	insinto /usr/share/sddm/themes/sddm-klpod221-theme
	doins -r Assets Components Previews Main.qml background1.jpg background2.jpg theme.conf
}
