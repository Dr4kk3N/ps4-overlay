# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

DESCRIPTION=".NET is a free, cross-platform, open-source developer platform"
HOMEPAGE="https://dotnet.microsoft.com/"
LICENSE="MIT"

SRC_URI="
amd64? ( https://dotnetcli.azureedge.net/dotnet/Runtime/${PV}/dotnet-runtime-${PV}-linux-x64.tar.gz )
arm? ( https://dotnetcli.azureedge.net/dotnet/Runtime/${PV}/dotnet-runtime-${PV}-linux-arm.tar.gz )
arm64? ( https://dotnetcli.azureedge.net/dotnet/Runtime/${PV}/dotnet-runtime-${PV}-linux-arm64.tar.gz )
"

SLOT="$(ver_cut 1-2)"
KEYWORDS="~amd64 ~arm ~arm64"
IUSE="+dotnet-symlink kerberos lttng"
REQUIRED_USE="elibc_glibc"
QA_PREBUILT="*"
RESTRICT="splitdebug"
RDEPEND="
	kerberos? ( app-crypt/mit-krb5:0/0 )
	lttng? ( dev-util/lttng-ust:0 )
	sys-libs/zlib:0/1
	dotnet-symlink? (
		!dev-dotnet/dotnet-sdk[dotnet-symlink(+)]
		!dev-dotnet/dotnet-sdk-bin[dotnet-symlink(+)]
		!dev-dotnet/dotnet-runtime[dotnet-symlink(+)]
	)
"

S=${WORKDIR}

delete() {
	test -n "$(find . -name "$1" -print -delete)"
}

src_compile() {
	use kerberos || delete libSystem.Net.Security.Native.so || die
	use lttng || delete libcoreclrtraceptprovider.so || die
}

src_install() {
	local dest="opt/${PN}-${SLOT}"
	dodir "${dest%/*}"

	{ mv "${S}" "${ED}/${dest}" && mkdir "${S}" && fperms 0755 "/${dest}"; } || die

	if use dotnet-symlink; then
		dosym "../../${dest}/dotnet" "/usr/bin/dotnet"
		dosym "../../${dest}/dotnet" "/usr/bin/dotnet-${SLOT}"
		dosym "../../${dest}/dotnet" "/usr/bin/dotnet-bin-${SLOT}"

		# set an env-variable for 3rd party tools
		echo "DOTNET_ROOT=/${dest}" > "${T}/90${PN}-${SLOT}" || die
		doenvd "${T}/90${PN}-${SLOT}"
	fi
}
