# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_KDEINSTALLDIRS="false"
ECM_TEST="true"
ECM_EXAMPLES="true"
QTMIN=6.4.2
inherit ecm kde.org

DESCRIPTION="Library for writing accessibility clients such as screen readers"
HOMEPAGE="https://community.kde.org/Accessibility
https://invent.kde.org/libraries/libqaccessibilityclient"

LICENSE="LGPL-2.1"
SLOT="6"
IUSE=""

# tests require DBus
RESTRICT="test"

DEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[dbus,gui,widgets]
"
RDEPEND="${DEPEND}"
