# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KDE_ORG_CATEGORY="pim"
KFMIN=5.240.0
QTMIN=6.4.2
inherit ecm kde.org

DESCRIPTION="Library to expose vcards to KPeople"
HOMEPAGE="https://invent.kde.org/pim/kpeoplevcard"

LICENSE="LGPL-2.1+"
SLOT="6"

DEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[gui,widgets]
	>=kde-frameworks/kcontacts-${KFMIN}:6
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
	>=kde-frameworks/kpeople-${KFMIN}:6
"
RDEPEND="${DEPEND}"
