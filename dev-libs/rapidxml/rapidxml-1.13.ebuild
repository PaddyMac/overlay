# Copyright 2012 Funtoo Technologies
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="RapidXml is an attempt to create the fastest XML parser possible, while retaining useability, portability and reasonable W3C compatibility."
HOMEPAGE="http://rapidxml.sourceforge.net/"
SRC_URI="mirror://sourceforge/rapidxml/rapidxml-${PV}.zip"

LICENSE="MPL"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE=""

DEPEND=""
RDEPEND=""

src_install() {
    dodir /usr/include/rapidxml
    cp *.hpp "${D}/usr/include/rapidxml"
    dodoc license.txt manual.html
}

