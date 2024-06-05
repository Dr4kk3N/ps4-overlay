# Copyright 2019-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: github-pkg.eclass
# @MAINTAINER:
# flussence <gentoo+bugs@flussence.eu>
# @AUTHOR:
# flussence <gentoo+bugs@flussence.eu>
# @BLURB: Common code for GitHub-hosted packages
# @DESCRIPTION:
# The github-pkg eclass fills in git-r3 related variables with sensible defaults.
# By default, HOMEPAGE is set to the repo URL and EGIT_REPO_URI is derived from it.
# Upstreams tend to use wildly inconsistent tarball naming conventions, so no SRC_URI is provided.
# @SUPPORTED_EAPIS: 7 8

# @ECLASS_VARIABLE: GITHUB_USER
# @PRE_INHERIT
# @DEFAULT_UNSET
# @DESCRIPTION:
# Specify the owner name in the repository's URL; defaults to PN.

# @ECLASS_VARIABLE: GITHUB_PROJ
# @PRE_INHERIT
# @DEFAULT_UNSET
# @DESCRIPTION:
# Specify the project name in the repository's URL; defaults to PN.

# @ECLASS_VARIABLE: GITHUB_HOMEPAGE
# @OUTPUT_VARIABLE
# @DESCRIPTION:
# Computed path to the git repository; also used to set EGIT_REPO_URI if package version is 9999.

case ${EAPI:-0} in
	7|8)
		GITHUB_HOMEPAGE="https://github.com/${GITHUB_USER:-${PN}}/${GITHUB_PROJ:-${PN}}"
		: ${HOMEPAGE:=$GITHUB_HOMEPAGE}

		if [[ ${PV} == "9999" ]]; then
			: ${EGIT_REPO_URI:=${HOMEPAGE}.git}
			inherit git-r3
			KEYWORDS=""
		fi
		;;
	*)
		die "EAPI ${EAPI} is not supported by github-pkg.eclass"
		;;
esac
