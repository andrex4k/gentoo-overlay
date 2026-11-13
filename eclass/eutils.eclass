# Copyright 2026
# Distributed under the terms of the GNU General Public License v2
#
# Compatibility shim for eutils.eclass.
#
# eutils.eclass was removed from the Gentoo repository in 2024, but a number
# of vintage ebuilds in this overlay (logrotate, gnupg-9999, etoken-sac,
# csuser-plugin, qemu-user-9999, ...) still inherit it and call epatch() /
# epatch_user().  Rather than rewriting all of them, this file provides the
# two functions on top of the modern eapply API.
#
# New ebuilds must not inherit this eclass: use PATCHES + default in
# src_prepare(), and eapply_user() only if src_prepare() does not call
# default.

if [[ -z ${_EUTILS_ECLASS} ]]; then
_EUTILS_ECLASS=1

# @FUNCTION: epatch
# @USAGE: [patches...]
# @DESCRIPTION:
# Apply the given patches (or, with EPATCH_FORCE=yes and no arguments, every
# *.patch/*.diff file in EPATCH_SOURCE, which defaults to ${FILESDIR}).
# EPATCH_OPTS and EPATCH_STRIP are passed through to eapply().
epatch() {
	local src=${EPATCH_SOURCE:-${FILESDIR}}
	local -a patches=()
	local f

	if [[ $# -eq 0 ]]; then
		[[ ${EPATCH_FORCE} == yes ]] || return 0
		for f in "${src}"/*.patch "${src}"/*.diff; do
			[[ -f ${f} ]] || continue
			patches+=( "${f}" )
		done
		(( ${#patches[@]} > 0 )) || return 0
	else
		patches=( "$@" )
	fi

	# EPATCH_OPTS/EPATCH_STRIP are intentionally word-split, as the
	# original eclass did.
	# shellcheck disable=SC2086
	eapply ${EPATCH_OPTS} ${EPATCH_STRIP} "${patches[@]}"
}

# @FUNCTION: epatch_user
# @DESCRIPTION:
# Apply user patches.  EAPI 7+ applies them from default(); eapply_user()
# is a no-op when they have already been applied, so this is safe to call
# after default().
epatch_user() {
	eapply_user
}

fi
