# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
#
# This ebuild is derived from http://gpo.zugaina.org/Overlays/ROKO__ and http://gpo.zugaina.org/Overlays/gentoo-zh
# TODO: FontPatcher is not yet included in this ebuild. Will do that later, but PR are welcome :)

EAPI=8

inherit font check-reqs

DESCRIPTION="Collection of fonts that are patched to include a high number of glyphs (icons)."
HOMEPAGE="https://nerdfonts.com"
RESTRICT="mirror"

LICENSE="MIT
		OFL-1.1
		Apache-2.0
		CC-BY-SA-4.0
		BitstreamVera
		BSD
		WTFPL-2
		Vic-Fieger-License
		UbuntuFontLicense-1.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DIRNAME=(
  3270
  Agave
  AnonymousPro
  Arimo
  AurulentSansMono
  BigBlueTerminal
  BitstreamVeraSansMono
  CascadiaCode
  CodeNewRoman
  ComicShannsMono
  Cousine
  DaddyTimeMono
  DejaVuSansMono
  DroidSansMono
  FantasqueSansMono
  FiraCode
  FiraMono
  Go-Mono
  Gohu
  Hack
  Hasklig
  HeavyData
  Hermit
  iA-Writer
  IBMPlexMono
  Inconsolata
  InconsolataGo
  InconsolataLGC
  Iosevka
  IosevkaTerm
  JetBrainsMono
  Lekton
  LiberationMono
  Lilex
  Meslo
  Monofur
  Monoid
  Mononoki
  MPlus
  NerdFontsSymbolsOnly
  Noto
  OpenDyslexic
  Overpass
  ProFont
  ProggyClean
  RobotoMono
  ShareTechMono
  SourceCodePro
  SpaceMono
  Terminus
  Tinos
  Ubuntu
  UbuntuMono
  VictorMono
)

IUSE_FLAGS=(${DIRNAME[*],,})
IUSE="${IUSE_FLAGS[*]}"

MY_URI="https://github.com/ryanoasis/${PN}/releases/download/v${PV}"
TAG_URI="https://github.com/ryanoasis/nerd-fonts/raw/v${PV}"
SRC_URI="3270?            ( "${MY_URI}/3270.tar.xz" -> "3270-${PV}.tar.xz" )
	agave?                  ( "${MY_URI}/Agave.tar.xz" -> "Agave-${PV}.tar.xz" )
	anonymouspro?           ( "${MY_URI}/AnonymousPro.tar.xz" -> "AnonymousPro-${PV}.tar.xz"  )
	arimo?                  ( "${MY_URI}/Arimo.tar.xz" -> "Arimo-${PV}.tar.xz"  )
	aurulentsansmono?       ( "${MY_URI}/AurulentSansMono.tar.xz" -> "AurulentSansMono-${PV}.tar.xz"  )
	bigblueterminal?        ( "${MY_URI}/BigBlueTerminal.tar.xz" -> "BigBlueTerminal-${PV}.tar.xz"  )
	bitstreamverasansmono?  ( "${MY_URI}/BitstreamVeraSansMono.tar.xz" -> "BitstreamVeraSansMono-${PV}.tar.xz"  )
	cascadiacode?           ( "${MY_URI}/CascadiaCode.tar.xz" -> "CascadiaCode-${PV}.tar.xz"  )
	codenewroman?           ( "${MY_URI}/CodeNewRoman.tar.xz" -> "CodeNewRoman-${PV}.tar.xz"  )
	comicshannsmono?        ( "${MY_URI}/ComicShannsMono.tar.xz" -> "ComicShannsMono-${PV}.tar.xz"  )
	cousine?                ( "${MY_URI}/Cousine.tar.xz" -> "Cousine-${PV}.tar.xz"  )
	daddytimemono?          ( "${MY_URI}/DaddyTimeMono.tar.xz" -> "DaddyTimeMono-${PV}.tar.xz"  )
	dejavusansmono?         ( "${MY_URI}/DejaVuSansMono.tar.xz" -> "DejaVuSansMono-${PV}.tar.xz"  )
	droidsansmono?          ( "${MY_URI}/DroidSansMono.tar.xz" -> "DroidSansMono-${PV}.tar.xz"  )
	fantasquesansmono?      ( "${MY_URI}/FantasqueSansMono.tar.xz" -> "FantasqueSansMono-${PV}.tar.xz"  )
	firacode?               ( "${MY_URI}/FiraCode.tar.xz" -> "FiraCode-${PV}.tar.xz"  )
	firamono?               ( "${MY_URI}/FiraMono.tar.xz" -> "FiraMono-${PV}.tar.xz"  )
	go-mono?                ( "${MY_URI}/Go-Mono.tar.xz" -> "Go-Mono-${PV}.tar.xz"  )
	gohu?                   ( "${MY_URI}/Gohu.tar.xz" -> "Gohu-${PV}.tar.xz"  )
	hack?                   ( "${MY_URI}/Hack.tar.xz" -> "Hack-${PV}.tar.xz"  )
	hasklig?                ( "${MY_URI}/Hasklig.tar.xz" -> "Hasklig-${PV}.tar.xz"  )
	heavydata?              ( "${MY_URI}/HeavyData.tar.xz" -> "HeavyData-${PV}.tar.xz"  )
	hermit?                 ( "${MY_URI}/Hermit.tar.xz" -> "Hermit-${PV}.tar.xz"  )
	ia-writer?              ( "${MY_URI}/iA-Writer.tar.xz" -> "iA-Writer-${PV}.tar.xz"  )
	ibmplexmono?            ( "${MY_URI}/IBMPlexMono.tar.xz" -> "IBMPlexMono-${PV}.tar.xz"  )
	inconsolata?            ( "${MY_URI}/Inconsolata.tar.xz" -> "Inconsolata-${PV}.tar.xz"  )
	inconsolatago?          ( "${MY_URI}/InconsolataGo.tar.xz" -> "InconsolataGo-${PV}.tar.xz"  )
	inconsolatalgc?         ( "${MY_URI}/InconsolataLGC.tar.xz" -> "InconsolataLGC-${PV}.tar.xz"  )
	iosevka?                ( "${MY_URI}/Iosevka.tar.xz" -> "Iosevka-${PV}.tar.xz"  )
	iosevkaterm?            ( "${MY_URI}/IosevkaTerm.tar.xz" -> "IosevkaTerm-${PV}.tar.xz"  )
	jetbrainsmono?          ( "${MY_URI}/JetBrainsMono.tar.xz" -> "JetBrainsMono-${PV}.tar.xz"  )
	lekton?                 ( "${MY_URI}/Lekton.tar.xz" -> "Lekton-${PV}.tar.xz"  )
	liberationmono?         ( "${MY_URI}/LiberationMono.tar.xz" -> "LiberationMono-${PV}.tar.xz"  )
	lilex?                  ( "${MY_URI}/Lilex.tar.xz" -> "Lilex-${PV}.tar.xz"  )
	meslo?                  ( "${MY_URI}/Meslo.tar.xz" -> "Meslo-${PV}.tar.xz"  )
	monofur?                ( "${MY_URI}/Monofur.tar.xz" -> "Monofur-${PV}.tar.xz"  )
	monoid?                 ( "${MY_URI}/Monoid.tar.xz" -> "Monoid-${PV}.tar.xz"  )
	mononoki?               ( "${MY_URI}/Mononoki.tar.xz" -> "Mononoki-${PV}.tar.xz"  )
	mplus?                  ( "${MY_URI}/MPlus.tar.xz" -> "MPlus-${PV}.tar.xz"  )
	nerdfontssymbolsonly?   ( "${MY_URI}/NerdFontsSymbolsOnly.tar.xz" -> "NerdFontsSymbolsOnly-${PV}.tar.xz"  "${TAG_URI}/10-nerd-font-symbols.conf" -> "10-nerd-font-symbols.conf-${PV}" )
	noto?                   ( "${MY_URI}/Noto.tar.xz" -> "Noto-${PV}.tar.xz"  )
	opendyslexic?           ( "${MY_URI}/OpenDyslexic.tar.xz" -> "OpenDyslexic-${PV}.tar.xz"  )
	overpass?               ( "${MY_URI}/Overpass.tar.xz" -> "Overpass-${PV}.tar.xz"  )
	profont?                ( "${MY_URI}/ProFont.tar.xz" -> "ProFont-${PV}.tar.xz"  )
	proggyclean?            ( "${MY_URI}/ProggyClean.tar.xz" -> "ProggyClean-${PV}.tar.xz"  )
	robotomono?             ( "${MY_URI}/RobotoMono.tar.xz" -> "RobotoMono-${PV}.tar.xz"  )
	sharetechmono?          ( "${MY_URI}/ShareTechMono.tar.xz" -> "ShareTechMono-${PV}.tar.xz"  )
	sourcecodepro?          ( "${MY_URI}/SourceCodePro.tar.xz" -> "SourceCodePro-${PV}.tar.xz"  )
	spacemono?              ( "${MY_URI}/SpaceMono.tar.xz" -> "SpaceMono-${PV}.tar.xz"  )
	terminus?               ( "${MY_URI}/Terminus.tar.xz" -> "Terminus-${PV}.tar.xz"  )
	tinos?                  ( "${MY_URI}/Tinos.tar.xz" -> "Tinos-${PV}.tar.xz"  )
	ubuntu?                 ( "${MY_URI}/Ubuntu.tar.xz" -> "Ubuntu-${PV}.tar.xz"  )
	ubuntumono?             ( "${MY_URI}/UbuntuMono.tar.xz" -> "UbuntuMono-${PV}.tar.xz"  )
	victormono?             ( "${MY_URI}/VictorMono.tar.xz" -> "VictorMono-${PV}.tar.xz"  )"

DEPEND="app-arch/xz-utils"
RDEPEND="media-libs/fontconfig"

CHECKREQS_DISK_BUILD="4G"
CHECKREQS_DISK_USR="4G"

S="${WORKDIR}"
FONT_CONF=(
	"${FILESDIR}"/10-nerd-font-symbols.conf
)
FONT_S=${S}

pkg_pretend() {
	check-reqs_pkg_setup
}
src_prepare() {
	if use nerdfontssymbolsonly ; then
		install -m644 "${DISTDIR}/10-nerd-font-symbols.conf-${PV}" "${S}/10-nerd-font-symbols.conf" || die
	fi

	default
}

src_install() {
	declare -A font_filetypes
	local otf_file_number ttf_file_number

	otf_file_number=$(find ${S} -regex '.*\.otf' | wc -l)
	ttf_file_number=$(find ${S} -regex '.*\.ttf' | wc -l)

	if [[ ${otf_file_number} != 0 ]]; then
		font_filetypes[otf]=
	fi

	if [[ ${ttf_file_number} != 0 ]]; then
		font_filetypes[ttf]=
	fi

	FONT_SUFFIX="${!font_filetypes[@]}"

	font_src_install
}

pkg_postinst() {
	einfo "Installing font-patcher via an ebuild is hard, because paths are hardcoded differently"
	einfo "in .sh files. You can still get it and use it by git cloning the nerd-font project and"
	einfo "running it from the cloned directory."
	einfo "https://github.com/ryanoasis/nerd-fonts"

	elog "You might have to enable 50-user.conf and 10-nerd-font-symbols.conf by using"
	elog "eselect fontconfig"
}
