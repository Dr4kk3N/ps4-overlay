
# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop

RNAME="2023-06"
SR="R"

DESCRIPTION="Eclipse IDE for C/C++"
HOMEPAGE="http://www.eclipse.org"

SRC_BASE="https://www.eclipse.org/downloads/download.php?file=/technology/epp/downloads/release/${RNAME}/${SR}/eclipse-cpp-${RNAME}-${SR}-linux-gtk"
#SRC_BASE="https://mirrors.xmission.com/eclipse/technology/epp/downloads/release/${RNAME}/${SR}/eclipse-cpp-${RNAME}-${SR}-linux-gtk"
SRC_URI="
	amd64? ( ${SRC_BASE}-x86_64.tar.gz&r=1 -> ${P}-x86_64.tar.gz )
"

LICENSE="EPL-1.0"
SLOT="4.28"
KEYWORDS="-* ~amd64"
IUSE=""

CDEPEND="
	>=dev-java/slf4j-api-2.0.7:0
	>=dev-java/icu4j-73.2:70
        >=dev-java/commons-httpclient-3.1-r2:3
        >=dev-java/javax-inject-1-r4:0
        >=dev-java/jsr305-3.0.2:0
        >=dev-java/xml-commons-resolver-1.2-r3:0
        "
DEPEND="${CDEPEND}"
RDEPEND="
	>=virtual/jdk-1.8
	x11-libs/gtk+:3
	${CDEPEND}"

S="${WORKDIR}"/eclipse

HTML_DOCS="readme/"

_unbundle_single() {
        local mode="${1}" destination_jar="${2}" package="${3}" package_jar="${4}"
        local abs_destination_jar="${PWD}/${destination_jar}"
        local backup_dir="${T}"/${destination_jar##*/}.dir

        if [[ "${mode}" = delete ]]; then
                # Backup META-INF/MANIFEST.MF with checksums
                # Then delete .jar file
                mkdir -p "${backup_dir}"/META-INF
                unzip -p "${destination_jar}" META-INF/MANIFEST.MF \
                                | sed -e '/^Name:/d' -e '/^SHA1-Digest:/d' -e '/^\s*$/d' \
                                > "${backup_dir}"/META-INF/MANIFEST.MF || die
                rm "${destination_jar}" || die
        elif [[ "${mode}" = wire ]]; then
                einfo "Replacing bundled ${destination_jar}..."
                # Create new .jar based on system-wide build
                # In the process, apply META-INF/MANIFEST.MF backup
                java-pkg_jar-from "${package}" "${package_jar}" "${destination_jar}"
                local source_jar="$(readlink -f "${destination_jar}")"
                rm "${destination_jar}" || die

                cp "${source_jar}" "${destination_jar}" || die
                ( cd "${backup_dir}" \
                                && [[ -f "${abs_destination_jar}" ]] \
                                && zip "${abs_destination_jar}" META-INF/MANIFEST.MF >/dev/null
                ) || die
        fi
}

_unbundle_known() {
        local mode="${1}"

        # https://wiki.gentoo.org/wiki/Eclipse/Building_From_Source
#	_unbundle_single "${mode}" plugins/org.slf4j.api_1.7.30.v20221112-0806.jar slf4j-api slf4j-api.jar
         _unbundle_single "${mode}" plugins/com.ibm.icu_73.1.0.jar icu4j-70 icu4j.jar
#        _unbundle_single "${mode}" plugins/javax.annotation_1.3.5.v20230504-0748.jar jsr305 jsr305.jar
#        _unbundle_single "${mode}" plugins/javax.inject_1.0.0.v20220405-0441.jar javax-inject javax-inject.jar
#        _unbundle_single "${mode}" plugins/org.apache.commons.httpclient_3.1.0.v201012070820.jar commons-httpclient-3 commons-httpclient.jar
#        _unbundle_single "${mode}" plugins/org.apache.xml.resolver_1.2.0.v20220715-1206.jar xml-commons-resolver xml-commons-resolver.jar
}

src_prepare() {
        _unbundle_known delete

        ewarn 'Binary dependencies left to unbundle:'
        ewarn "$(find -type f -name '*.jar' -not -wholename '*/org.eclipse*' | sort | sed 's,^\./,,')"

        _unbundle_known wire

        cp "${FILESDIR}"/${P}-eclipse-bin "${T}/eclipse-bin-${SLOT}" || die
        cp "${FILESDIR}"/${P}-eclipserc-bin "${T}/eclipserc-bin-${SLOT}" || die
        sed "s,%SLOT%,${SLOT},g" -i "${T}"/eclipse{,rc}-bin-${SLOT} || die

        eapply_user
}

src_install() {
	local dest=/opt/${PN}-${SLOT}

	insinto ${dest}
	doins -r features icon.xpm plugins artifacts.xml p2 eclipse.ini configuration dropins

	exeinto ${dest}
	doexe eclipse

	einstalldocs

	cp "${FILESDIR}"/${P}-eclipserc-bin "${T}/eclipserc-bin-${SLOT}" || die
	cp "${FILESDIR}"/${P}-eclipse-bin "${T}/eclipse-bin-${SLOT}" || die
	sed "s@%SLOT%@${SLOT}@" -i "${T}"/eclipse{,rc}-bin-${SLOT} || die

	insinto /etc
	newins "${T}"/eclipserc-bin-${SLOT} eclipserc-bin-${SLOT}

	newbin "${T}"/eclipse-bin-${SLOT} eclipse-cpp-${SLOT}
	make_desktop_entry "eclipse-cpp-${SLOT}" "Eclipse" "${dest}/icon.xpm" "Development;IDE"
}
