#!/sbin/openrc-run
# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

description="Save/restore system clock on machines without working RTC hardware"

depend() {
    after bootmisc
}

start() {
    ebegin "Restore the current clock"
	fake-hwclock load
    eend $?
}

stop() {
    ebegin "Save the current clock"
	fake-hwclock save
    eend $?
}