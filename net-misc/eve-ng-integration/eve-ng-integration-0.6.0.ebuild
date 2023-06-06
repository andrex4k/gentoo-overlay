# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit xdg

if [[ ${PV} == "9999" ]] ; then
        inherit git-r3
        EGIT_REPO_URI="https://github.com/SmartFinn/${PN}.git"
else
        SRC_URI="https://github.com/SmartFinn/${PN}/archive/refs/tags/v${PV}.tar.gz"
        KEYWORDS="~amd64"
fi

DESCRIPTION="Integrates EVE-NG with Linux desktop"
HOMEPAGE="https://git.io/eve-ng-integration"

LICENSE="MIT"

SLOT="0"

IUSE=""

#src_unpack() {
#	default
#}
#
src_prepare () {
        default
}

pkg_setup() {
	emake install
}
#
#pkg_postinst() {
#        xdg_desktop_database_update
#        xdg_icon_cache_update
#        xdg_mimeinfo_database_update
#}
#
#pkg_postrm() {
#        xdg_desktop_database_update
#        xdg_icon_cache_update
#        xdg_mimeinfo_database_update
#}
