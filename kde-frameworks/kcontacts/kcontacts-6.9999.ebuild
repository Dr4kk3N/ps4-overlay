# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_TEST="true"
PVCUT=$(ver_cut 1-2)
QTMIN=6.4.2
inherit ecm frameworks.kde.org

DESCRIPTION="Address book API based on KDE Frameworks"

LICENSE="GPL-2+"
KEYWORDS=""
IUSE=""

RDEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[gui]
	=kde-frameworks/kcodecs-${PVCUT}*:6
	=kde-frameworks/kconfig-${PVCUT}*:6
	=kde-frameworks/kcoreaddons-${PVCUT}*:6
	=kde-frameworks/ki18n-${PVCUT}*:6
"
DEPEND="${RDEPEND}
	test? ( >=dev-qt/qtdeclarative-${QTMIN}:6 )
"

src_test() {
	# bug #566648 (access to /dev/dri/card0 denied)
	# bug #838502 (again some Qt translations loading related err...)
	local myctestargs=(
		-E "(kcontacts-addresstest|kcontacts-picturetest)"
	)
	ecm_src_test
}
