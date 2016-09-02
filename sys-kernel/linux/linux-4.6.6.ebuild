# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

ETYPE="kernel"

inherit linux-kernel

src_prepare() {
	# Set DEFAULT_CONSOLE_LOGLEVEL to 4 (same value as the 'quiet' kernel param).
	# Remove this when a Kconfig knob is made available by upstream
	# (relevant patch sent upstream: https://lkml.org/lkml/2011/7/26/227).
	epatch "${FILESDIR}/change-default-console-loglevel.patch"

	linux-kernel_src_prepare
}
