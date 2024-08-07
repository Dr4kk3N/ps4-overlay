# Generated via: https://github.com/arran4/arrans_overlay/blob/main/.github/workflows/
EAPI=8

DESCRIPTION="User-friendly Desktop Client App for AI Models/LLMs (GPT, Claude, Gemini, Ollama...)"
HOMEPAGE="https://chatboxai.app"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

DEPEND=""
RDEPEND=""

S="${WORKDIR}"
RESTRICT="strip"

inherit xdg-utils

SRC_URI="
  amd64? ( https://download.chatboxai.app/releases/Chatbox-${PV}-x86_64.AppImage -> $P.amd64 )
  arm64? ( https://download.chatboxai.app/releases/Chatbox-${PV}-arm64.AppImage -> $P.arm64 )
"

src_unpack() {
  cp "${DISTDIR}/${A}" "${A}" || die "Can't copy archive file"
  chmod a+x "${A}" || die "Can't chmod archive file"
  ./${A} --appimage-extract xyz.chatboxapp.app.desktop || die "Can't extract .desktop file from AppImage"
  ./${A} --appimage-extract usr/share/icons || die "Can't extract icons from AppImage"
}

src_prepare() {
  sed -i 's:^Exec=.*:Exec=/opt/bin/ChatBox.AppImage:' squashfs-root/*.desktop
  sed -i 's:^Icon=.*:Icon=/usr/share/icons/hicolor/512x512/apps/xyz.chatboxapp.app.png:' squashfs-root/*.desktop
  sed -i 's:^TryExec=.*:TryExec=/opt/bin/ChatBox.AppImage:' squashfs-root/*.desktop
  eapply_user
}

src_install() {
  mv "${WORKDIR}/${P}.amd64" "${WORKDIR}/ChatBox.AppImage"
  exeinto /opt/bin
  doexe "${WORKDIR}/ChatBox.AppImage" || die "Failed to install AppImage"
  dosym /opt/bin/ChatBox.AppImage /usr/bin/ChatBox
  insinto /usr/share/applications
  doins "${WORKDIR}/squashfs-root/xyz.chatboxapp.app.desktop" || die "Failed to install .desktop file"
  insinto /usr/share/icons
  doins -r "${WORKDIR}/squashfs-root/usr/share/icons/hicolor" || die "Failed to install icons"
}

pkg_postinst() {
  xdg_desktop_database_update
}
