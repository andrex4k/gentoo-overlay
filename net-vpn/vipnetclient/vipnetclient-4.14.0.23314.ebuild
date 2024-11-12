# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit rpm

DESCRIPTION="ViPNet Client for Linux GUI by JSC InfoTeCS"
HOMEPAGE="https://www.vipnet.ru"
SRC_URI="https://dl.uploadgram.me/63bb0e83d26c2g?raw -> vipnetclient-gui-gost-${PV}.rpm"


LICENSE=""
SLOT="0"
KEYWORDS="amd64"
RESTRICT="bindist mirror strip"


RDEPEND="
	x11-libs/libxkbcommon
	x11-libs/libxcb
"

S=${WORKDIR}

pkg_setup() {

	rm -rf /tmp/vipnetclient
	mkdir -p /tmp/vipnetclient

	# Creating file-markers on each existing vipnetclient process and send them USR1
	for pid in $(pgrep -U0 -x vipnetclient); do
		local user=$(grep -awz USER /proc/${pid}/environ 2>/dev/null | tr -d '\0' | cut -c 6-)
		[ -z "$user" ] && continue
		echo ${pid} > /tmp/vipnetclient/${user}
	done

}

src_unpack() {

	rpm_src_unpack ${A}

	# Переименуем папку systemd чтобы не попал под фильтр INSTALL-MASK
	mv ${S}/etc/systemd ${S}/etc/_systemd

}

src_install() {

	mv * "${D}" || die
}

pkg_postinst() {

	# Копируем файлы службы для systemd, без них не работает
	mv /etc/_systemd/system /etc/systemd
	rm -rf /etc/_systemd

	# update man db
	mandb >/dev/null 2>&1

	# for some distrs
	find /var/lib/vipnet -type d -exec chmod 755 {} \;

	xdg_icon_cache_update
	xdg_mimeinfo_database_update
	xdg_desktop_database_update

	# create service and init scripts
	if which systemctl >/dev/null 2>&1; then
		systemctl reset-failed
		systemctl stop vipnetclientdaemon*
	elif which rc-update	>/dev/null 2>&1; then
		rc-update add vipnetclient default >/dev/null 2>&1
	fi

	/usr/bin/vipnetclient --setcap --version

	# Update shared libraries paths
	ldconfig 2>/dev/null
}

#
pkg_prerm ()  {

	# Удалим мусор
	rm -rf /etc/systemd/system/vipnetclient_gui_login*

	# Размонтируем виртуальный диск
	umount /home/*/.vipnet/var/run
	umount /root/.vipnet/var/run

}
