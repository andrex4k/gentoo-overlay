# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3 flag-o-matic toolchain-funcs patches

SLOT="0"

LICENSE="MPL-2.0"

IUSE=""

DESCRIPTION="Cross platform utilities useful for performing various operations on SATA, SAS, NVMe, and USB storage devices."

HOMEPAGE="https://github.com/Seagate/openSeaChest"

# Point to any required sources; these will be automatically downloaded by
# Portage.

EGIT_REPO_URI="https://github.com/Seagate/openSeaChest.git"
EGIT_SUBMODULES=( '*'
				-/{opensea-common,opensea-operations,opensea-transport,wingetopt}
 				)
#EGIT_OVERRIDE_REPO_SEAGATE_OPENSEACHEST
#EGIT_OVERRIDE_BRANCH_SEAGATE_OPENSEACHEST
#EGIT_OVERRIDE_COMMIT_SEAGATE_OPENSEACHEST
#EGIT_OVERRIDE_COMMIT_DATE_SEAGATE_OPENSEACHEST

if [[ ${PV} == *9999* ]]; then
	#EGIT_BRANCH="developer"
	KEYWORDS=""
else
	#EGIT_BRANCH="master"
	EGIT_COMMIT="v${PV}"
	KEYWORDS="~*"
fi

#S="${WORKDIR}/${P}"
#BUILDDIR="${S}/Make/gcc"
S="${WORKDIR}/${P}/Make/gcc"
BDEPEND="sys-devel/gcc
		"


# The following src_configure function is implemented as default by portage, so
# you only need to call it if you need a different behaviour.
#src_configure() {
	# Most open-source packages use GNU autoconf for configuration.
	# The default, quickest (and preferred) way of running configure is:
	#econf
	#
	# You could use something similar to the following lines to
	# configure your package before compilation.  The "|| die" portion
	# at the end will stop the build process if the command fails.
	# You should use this at the end of critical commands in the build
	# process.  (Hint: Most commands are critical, that is, the build
	# process should abort if they aren't successful.)
	#./configure \
	#	--host=${CHOST} \
	#	--prefix=/usr \
	#	--infodir=/usr/share/info \
	#	--mandir=/usr/share/man || die
	# Note the use of --infodir and --mandir, above. This is to make
	# this package FHS 2.2-compliant.  For more information, see
	#   https://wiki.linuxfoundation.org/lsb/fhs
#}

# The following src_compile function is implemented as default by portage, so
# you only need to call it, if you need different behaviour.
src_compile() {
	# emake is a script that calls the standard GNU make with parallel
	# building options for speedier builds (especially on SMP systems).
	# Try emake first.  It might not work for some packages, because
	# some makefiles have bugs related to parallelism, in these cases,
	# use emake -j1 to limit make to a single process.  The -j1 is a
	# visual clue to others that the makefiles have bugs that have been
	# worked around.
	
	
	MAKEOPTS="${MAKEOPTS} " make release
}

# The following src_install function is implemented as default by portage, so
# you only need to call it, if you need different behaviour.
src_install() {
	# You must *personally verify* that this trick doesn't install
	# anything outside of DESTDIR; do this by reading and
	# understanding the install part of the Makefiles.
	# This is the preferred way to install.
	
	make -j1 install

	# When you hit a failure with emake, do not just use make. It is
	# better to fix the Makefiles to allow proper parallelization.
	# If you fail with that, use "emake -j1", it's still better than make.

	# For Makefiles that don't make proper use of DESTDIR, setting
	# prefix is often an alternative.  However if you do this, then
	# you also need to specify mandir and infodir, since they were
	# passed to ./configure as absolute paths (overriding the prefix
	# setting).
	#emake \
	#	prefix="${D}"/usr \
	#	mandir="${D}"/usr/share/man \
	#	infodir="${D}"/usr/share/info \
	#	libdir="${D}"/usr/$(get_libdir) \
	#	install
	# Again, verify the Makefiles!  We don't want anything falling
	# outside of ${D}.
}
