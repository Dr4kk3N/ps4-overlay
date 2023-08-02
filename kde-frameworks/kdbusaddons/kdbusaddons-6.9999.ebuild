# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

QTMIN=6.4.2
VIRTUALDBUS_TEST="true"
inherit ecm frameworks.kde.org

DESCRIPTION="Framework for registering services and applications per freedesktop standards"

LICENSE="LGPL-2+"
KEYWORDS=""
IUSE="X"

DEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[dbus]
"
RDEPEND="${DEPEND}"
BDEPEND=">=dev-qt/qttools-${QTMIN}:6[linguist]"

src_configure() {
	local mycmakeargs=(
		)

	ecm_src_configure
}