# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit systemd git-r3

DESCRIPTION="Hardware PS4 FAN control util"
HOMEPAGE="https://github.com/Ps3itaTeam/ps4fancontrol"

EGIT_REPO_URI="https://github.com/Ps3itaTeam/ps4fancontrol.git"

LICENSE="GPL-2+ LGPL-2.1"
SLOT="0"

KEYWORDS="~amd64"

RDEPEND=""
DEPEND="${RDEPEND}
	>=x11-libs/xforms-1.2.4-r1"

