# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=8

WX_GTK_VER="3.0"

inherit cmake-utils git-r3 wxwidgets

DESCRIPTION="A Free, open source, cross platform C,C++,PHP and Node.js IDE"
HOMEPAGE="http://www.codelite.org"
EGIT_REPO_URI="git://github.com/eranif/${PN}.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="clang flex mysql pch sftp webview"

DEPEND="
	dev-db/sqlite:*

	net-libs/libssh

	x11-libs/wxGTK:3.0

	mysql? ( virtual/mysql )
"

RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}/codelite_dont_strip.patch"
}

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_enable clang CLANG)
		$(cmake-utils_use_with flex FLEX)
		$(cmake-utils_use_with mysql MYSQL)
		$(cmake-utils_use_with pch PCH)
		$(cmake-utils_use_enable sftp SFTP)
		$(cmake-utils_use_with webview WEBVIEW)
	)

	cmake-utils_src_configure
}
