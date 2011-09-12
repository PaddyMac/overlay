# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-wireless/madwifi-ng/madwifi-ng-0.9.2.1.ebuild,v 1.8 2007/02/20 12:12:40 genstef Exp $

inherit linux-mod

MY_P=${PN/ati-/}-${PV}
S=${WORKDIR}

DESCRIPTION="Generic V4L2 driver for ATI Mach64-based tv cards (All-in-Wonder, etc)"
HOMEPAGE="http://www.rulerofearth.com/"
SRC_URI="http://www.rulerofearth.com/${MY_P}.tbz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"

IUSE=""
DEPEND=""
RDEPEND=""

CONFIG_CHECK="VIDEO_DEV VIDEO_V4L1_COMPAT VIDEO_V4L2"
ERROR_VIDEO_DEV="${P} requires Video For Linux support (CONFIG_VIDEO_DEV)."
ERROR_VIDEO_V4L1_COMPAT="${P} requires Video For Linux API 1 compatible Layer (CONFIG_VIDEO_V4L1_COMPAT)."
ERROR_VIDEO_V4L2="${P} requires Video For Linux API 2 support (CONFIG_VIDEO_V4L2)."
BUILD_TARGETS="default"

pkg_setup() {
	linux-mod_pkg_setup

	MODULE_NAMES="genericv4l(v4l:${S}/v4l2)"

	BUILD_PARAMS="KDIR=${KV_OUT_DIR}"
}

src_unpack() {
	unpack ${A}
	# epatches go here if required
}

src_compile() {
	# assists in debugging
#	emake KERNELPATH=${KV_OUT_DIR} info || die "emake info failed"

	linux-mod_src_compile
}

src_install() {
	linux-mod_src_install

	dodoc v4l2/README_ENG.TXT v4l2/README_FR.TXT
}

pkg_postinst() {
	local moddir="${ROOT}/lib/modules/${KV_FULL}/v4l/"

	einfo "Removing old modules (just in case)"
	[[ -f "${moddir}/genericv4l.${KV_OBJ}" ]] && rm "${moddir}/genericv4l.${KV_OBJ}"

	linux-mod_pkg_postinst

	einfo
	einfo "NOTE: if you load the module and Tuner is not found"
	einfo "(look in dmesg) you can try to specify the tuner with the tunertype parameter"
	einfo "If you have a SECAM tuner you MUST specify tunertype=2"
	einfo
	ewarn "If you are using GATOS as well, keep in mind that you cannot use"
	ewarn "both at the same time (you CANNOT watch tv in overlay mode and use"
	ewarn "my driver to capture video at the same time)"
	einfo
}
