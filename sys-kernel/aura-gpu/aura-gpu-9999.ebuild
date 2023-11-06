# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Source: Written from scratch for sunset-repo overlay

EAPI=8

inherit git-r3 linux-mod-r1

DESCRIPTION="i2c driver for Asus AURA RGB lighting in GPUs"
HOMEPAGE="https://github.com/galkinvv/aura-gpu-i2c"
EGIT_REPO_URI="${HOMEPAGE}.git"

LICENSE="GPL-2"
SLOT="0"
if [[ "${PV%9999}" == "${PV}" ]] ; then
	KEYWORDS="~amd64 ~x86"
fi

src_prepare() {
	# Extra PCI IDs from various never-merged issues and PRs in forks
	sed \
	-e '/{0, 0, 0}/i\    {0x1002, 0x67df, 0x1043, 0x04c2, 0, 0, CHIP_POLARIS10},     // RX570 (Strix)' \
	-e '/{0, 0, 0}/i\    {0x1002, 0x731f, 0x1da2, 0xe410, 0, 0, CHIP_NAVI10},        // RX5700XT (Sapphire)' \
	-e '/{0, 0, 0}/i\    {0x1002, 0x67df, 0x1043, 0x0588, 0, 0, CHIP_POLARIS10},     // RX570 8G (Strix)' \
	-e '/{0, 0, 0}/i\    {0x1002, 0x67df, 0x1043, 0x0519, 0, 0, CHIP_POLARIS10},     // RX580 (Strix TOP)' \
	-e '/{0, 0, 0}/i\    {0x1002, 0x67FF, 0x1043, 0x04BC, 0, 0, CHIP_POLARIS11},     // RX560' \
	-i "${S}/pci_ids.h"

	default
}

src_compile() {
	local modlist=( aura-gpu=extra )
	local modargs=( KERNEL_SOURCE_DIR="${KV_OUT_DIR}" )

	linux-mod-r1_src_compile
}
