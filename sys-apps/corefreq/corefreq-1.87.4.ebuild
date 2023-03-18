# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit linux-info linux-mod systemd toolchain-funcs


DESCRIPTION="CoreFreq is a CPU monitoring software designed for the 64-bits Processors."
HOMEPAGE="https://github.com/cyring/CoreFreq"

if [[ ${PV} == 9999* ]]; then
	EGIT_REPO_URI="https://github.com/cyring/${PN}.git"
	inherit git-r3
else
SRC_URI="https://github.com/cyring/CoreFreq/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
S=${WORKDIR}/CoreFreq-${PV}
fi

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-* ~amd64"

IUSE="systemd"

DEPEND="virtual/linux-sources"
RDEPEND="${DEPEND}"

pkg_setup() {
    use kernel_linux || die "CoreFreq ebuild only support linux"
	CONFIG_CHECK="~MODULES ~SMP ~X86_MSR ~HOTPLUG_CPU ~CPU_IDLE 
	~CPU_FREQ ~PM_SLEEP ~DMI ~XEN ~AMD_NB ~HAVE_PERF_EVENTS 
	~SCHED_MUQSS ~SCHED_BMQ ~SCHED_PDS"
	ERROR_MODULES="CONFIG_MODULES: is mandatory"
	ERROR_SMP="CONFIG_SMP: is mandatory"
	ERROR_X86_MSR="CONFIG_X86_MSR: is mandatory"
    linux-info_pkg_setup
}

src_compile() {
	linux-mod_src_compile
	set_arch_to_kernel
	default
}

src_install() {
	linux-mod_src_install
	default
	if use systemd; then
	systemd_dounit corefreqd.{service,socket}
	fi
	newinitd ${FILESDIR}/corefreqd.initd corefreqd
}
