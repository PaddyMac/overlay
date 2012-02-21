# Copyright 2012 Funtoo Technologies
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit eutils mono gnome2

DESCRIPTION="Makes giving files to others very simple"
HOMEPAGE="http://code.google.com/p/giver"
SRC_URI="http://giver.googlecode.com/files/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="doc"

RDEPEND=">=dev-dotnet/gtk-sharp-2
	>=dev-dotnet/glib-sharp-2
	>=dev-dotnet/pango-sharp-2
	>=dev-dotnet/gnome-sharp-2
	>=dev-dotnet/notify-sharp-0.4.0_pre20080912
	>=net-dns/avahi-0.6.10"

DEPEND="${RDEPEND}"

pkg_setup() {

	if ! built_with_use net-dns/avahi mono; then
		eerror "We need avahi-sharp"
		eerror "Please recompile net-dns/avahi with USE=\"mono\""
		die
	fi

}

src_unpack() {
	unpack ${A}
	cd ${S}/src
	epatch ${FILESDIR}/${PN}-username_face2.patch

	# Shouldn't depend on gtkdotnet-sharp
        export  GTK_DOTNET_20_LIBS=" " \
                GTK_DOTNET_20_CFLAGS=" "
}

pkg_postinst() {

	elog " To get this working avahi must be started, do this by issueing:"
	elog
	elog " $ /etc/init.d/avahi-daemon start"
	elog
	elog " Or you might just add it to the default runlevel for constant use:"
	elog
	elog " $ rc-update add avahi-daemon default"

}

