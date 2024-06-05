# Copyright 2021-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

GITHUB_USER="googlefonts"
GITHUB_PROJ="${PN%%-bin}"

DESCRIPTION="Google Noto Color Emoji, upstream-prebuilt version"
HOMEPAGE="https://fonts.google.com/noto https://github.com/googlefonts/noto-emoji"
LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="amd64 arm arm64 x86"

FONT_SUFFIX="ttf"

inherit font github-pkg

if [[ ${PV} != 9999 ]]; then
	SRC_URI="${GITHUB_HOMEPAGE}/archive/v${PV}.tar.gz -> ${P/-bin/}.tar.gz"
	S="${WORKDIR}/${GITHUB_PROJ}-${PV}/fonts"
else
	die "No v9999 defined"
fi
