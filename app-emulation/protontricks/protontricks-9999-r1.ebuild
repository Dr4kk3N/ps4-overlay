# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )
DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1 xdg-utils

DESCRIPTION="app-emulation/winetricks wrapper for Proton (Steam Play) games"
HOMEPAGE="https://github.com/Matoking/protontricks"

if [[ ${PV} = *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/Matoking/protontricks.git"
	KEYWORDS=""
else
	KEYWORDS="~amd64 ~x86"
	EGIT_COMMIT="${PV}"
	SRC_URI="https://github.com/Matoking/protontricks/archive/${PV}.tar.gz -> ${P}.tar.gz"
fi

LICENSE="GPL-3"
SLOT="0"
IUSE="+gui"

RDEPEND="app-emulation/winetricks
	$(python_gen_cond_dep '
		dev-python/setuptools[${PYTHON_USEDEP}]
		dev-python/vdf[${PYTHON_USEDEP}]
	')
	gui? ( gnome-extra/zenity
		|| (
			app-emulation/winetricks[gtk]
			app-emulation/winetricks[kde]
		)
	)"
BDEPEND="$(python_gen_cond_dep '
	dev-python/setuptools-scm[${PYTHON_USEDEP}]
')"

# Tarballs from PyPI do not contain tests, and we cannot use GitHub releases
# any more because they are incompatible with setuptools_scm.
RESTRICT="test"

DOCS=(CHANGELOG.md README.md)

pkg_postinst() {
	xdg_desktop_database_update

	elog

	if ! use gui; then
		ewarn "Please note that disabling USE=gui does *not* presently remove the --gui command-line option,"
		ewarn "it just means using this option will fail unless gnome-extra/zenity happens to be installed."
		ewarn
	fi

	elog "Protontricks can only find games for which a Proton prefix already exists."
	elog "Make sure to run a Proton game at least once before trying to use protontricks on it."
	elog
}

pkg_postrm() {
	xdg_desktop_database_update
}

