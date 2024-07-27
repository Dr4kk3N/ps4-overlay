# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# see: https://bugs.gentoo.org/704920

EAPI="8"

inherit systemd git-r3

DESCRIPTION="Save/restore system clock on machines without working RTC hardware"
HOMEPAGE="https://tracker.debian.org/pkg/fake-hwclock"
EGIT_REPO_URI="https://git.einval.com/git/fake-hwclock.git"
EGIT_COMMIT="00a0feb706bfc11e1e0dbaa887c603b8f9875c78"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64"

src_prepare() {
	sed -i -e 's:/etc/fake-hwclock.data:/var/lib/fake-hwclock/data:' fake-hwclock

	eapply_user
}

src_install() {
	insinto "/var/lib/fake-hwclock"
	date -u '+%Y-%m-%d %H:%M:%S' > "${T}/data"
	doins "${T}/data"

	into /
	dosbin fake-hwclock

	newinitd "${FILESDIR}/fake-hwclock.init.d" fake-hwclock

	systemd_dounit debian/fake-hwclock-load.service
	systemd_dounit debian/fake-hwclock-save.service
	systemd_dounit debian/fake-hwclock-save.timer

	doman fake-hwclock.8
	dodoc debian/changelog
}

pkg_postinst() {
	elog "To enable and start the services:"
	elog ""
	elog "systemctl enable --now fake-hwclock-load.service fake-hwclock-save.service fake-hwclock-save.timer"
}
