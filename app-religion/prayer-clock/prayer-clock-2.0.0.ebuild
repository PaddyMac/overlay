# Copyright 2008-2012 Funtoo Technologies
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit eutils autotools

DESCRIPTION="a small application to remind the users to pray several Catholic prayers"
HOMEPAGE="http://sourceforge.net/projects/prayerclock/"
SRC_URI="mirror://sourceforge/prayerclock/${P}.tar.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-cpp/gtkmm:2.4
	x11-libs/gtk+:2
	virtual/pkgconfig"
RDEPEND="${DEPEND}"

src_prepare() {
         eautoreconf
}

src_compile() {
	emake
}

src_install() {
	# Install binary
	dobin src/prayer-clock

	#Install documentation
	dodoc doc/changelog.txt doc/COPYING

	#Install data files
	dodir /usr/share/${PN}
	insinto /usr/share/${PN}
	doins res/prayer-clock.glade res/prayers.dtd res/prayers.xml

	#Install icon file
	doicon res/prayer-clock.png

	#Install icon in menu
	make_desktop_entry "${PN}" "Prayer Clock" "${PN}" "GTK;Education;"
}
