# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit git-r3

DESCRIPTION="Hardware PS4 FAN control util"
HOMEPAGE="https://github.com/Dr4kk3N/ps4fancontrol"

EGIT_REPO_URI="https://github.com/Dr4kk3N/ps4fancontrol.git"

LICENSE="GPL-2+ LGPL-2.1"
SLOT="0"

#KEYWORDS="~amd64"
KEYWORDS=""
IUSE="libnotify systemd"
RDEPEND="
	dev-libs/glib:2
	systemd? ( sys-apps/systemd:= )
	x11-libs/gtk+:3[X]
	x11-libs/libX11
	libnotify? ( >=x11-libs/libnotify-0.7 )"
DEPEND="${RDEPEND}
	>=x11-libs/xforms-1.2.4-r1"
