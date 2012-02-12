# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# Based on gentoo's modemmanager ebuild

EAPI=2

inherit eutils autotools cros-workon

# ModemManager likes itself with capital letters
MY_P=${P/modemmanager/ModemManager}

DESCRIPTION="Modem and mobile broadband management libraries"
HOMEPAGE="http://mail.gnome.org/archives/networkmanager-list/2008-July/msg00274.html"
#SRC_URI not defined because we get our source locally

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

RDEPEND=">=dev-libs/glib-2.16
        >=sys-apps/dbus-1.2
        dev-libs/dbus-glib
        net-dialup/ppp
        "

DEPEND=">=sys-fs/udev-145[extras]
        dev-util/pkgconfig
        dev-util/intltool
        "

src_configure() {
	eautoreconf || die "autoreconf failed"
	intltoolize --force
	econf || die "econf failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS ChangeLog NEWS README
	insinto /etc/init
	doins "${FILESDIR}/modemmanager.conf"
}

