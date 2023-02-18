# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit libretro

DESCRIPTION="RetroArch joypad autoconfig files"
HOMEPAGE="https://github.com/libretro/retroarch-joypad-autoconfig"
KEYWORDS=""

LICENSE="MIT"
SLOT="0"

RDEPEND="virtual/udev"
DEPEND="${RDEPEND}"

src_install() {
	insinto "${RETROARCH_DATA_DIR}"/autoconfig
	doins "${S}"/udev/*.cfg
}
