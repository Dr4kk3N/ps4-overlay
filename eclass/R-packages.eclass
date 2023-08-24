# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EXPORT_FUNCTIONS src_unpack src_configure src_compile src_install pkg_postinst

SLOT="0"
IUSE="byte-compile"

DEPEND="dev-lang/R:="
RDEPEND="${DEPEND}"
BDEPEND="${DEPEND}"

R-packages_src_unpack() {
	unpack ${A}
	if [[ -d "${PN//_/.}" ]] && [[ ! -d "${P}" ]]; then
		mv ${PN//_/.} ${P}
	fi
}

R-packages_src_configure() { :; }

R-packages_src_compile() {
	MAKEFLAGS="CFLAGS=${CFLAGS// /\\ } CXXFLAGS=${CXXFLAGS// /\\ } FFLAGS=${FFLAGS// /\\ } FCFLAGS=${FCFLAGS// /\\ } LDFLAGS=${LDFLAGS// /\\ }" \
		R CMD INSTALL . -l "${WORKDIR}" $(use byte-compile && echo "--byte-compile")
}

R-packages_src_install() {
	insinto /usr/$(get_libdir)/R/site-library
	doins -r "${WORKDIR}"/${PN//_/.}
}

R-packages_pkg_postinst() {
	if [[ "${_UNRESOLVABLE_PACKAGES:-}" ]]; then
		# _UNRESOLVABLE_PACKAGES is only set if it has more than zero items
		local _max=${#_UNRESOLVABLE_PACKAGES[*]} i=

		einfo "Dependency(-ies):"
		for (( i=0; i<${_max}; i++ )); do
			einfo "- ${_UNRESOLVABLE_PACKAGES[$i]}"
		done
		einfo 'are (is) suggested by upstream but could not be found.'
		einfo 'Please install it manually from the R interpreter if you need it.'
	fi
}
