# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils linux-mod subversion

DESCRIPTION="Kernel module for WebcamStudio."
HOMEPAGE="http://www.ws4gl.org/"
ESVN_REPO_URI="https://webcamstudio.svn.sourceforge.net/svnroot/webcamstudio/trunk/vloopback@891"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND="virtual/linux-sources"


MODULE_NAMES="webcamstudio(misc:${S})"
CONFIG_CHECK="VIDEO_DEV"

pkg_setup() {
	linux-mod_pkg_setup

	rm -f ${S}/Makefile

	BUILD_PARAMS="-C ${KV_DIR} SUBDIRS=${S} KERNEL_DIR=${KV_DIR}"
	BUILD_TARGETS="modules"
	MODULESD_WEBCAMSTUDIO_ENABLED="yes"
}

pkg_postinst() {
	linux-mod_pkg_postinst

	elog "To use WebcamStudio you need to have the \"webcamstudio\" module"
	elog "loaded first."
	elog ""
	elog "If you want to do it automatically, please add \"webcamstudio\" to:"
	if has_version sys-apps/openrc; then
		elog "/etc/conf.d/modules"
	else
		elog "/etc/modules.autoload.d/kernel-${KV_MAJOR}.${KV_MINOR}"
	fi
	elog ""
}


