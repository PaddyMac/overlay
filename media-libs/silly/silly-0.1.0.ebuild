# Copyright 2012 Funtoo Technologies
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit base

MY_P=SILLY-${PV}
MY_D=SILLY-DOCS-${PV}
inherit eutils
DESCRIPTION="Silly image codec"

HOMEPAGE="http://www.cegui.org.uk/wiki/index.php/SILLY"

SRC_URI="mirror://sourceforge/crayzedsgui/${MY_P}.tar.gz
	doc? ( mirror://sourceforge/crayzedsgui/${MY_D}.tar.gz )"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~x86"
IUSE="debug doc inline profiling jpeg png"

DEPEND="jpeg? ( virtual/jpeg )
	png? ( media-libs/libpng )
	sys-libs/zlib"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-libpng-1.5.patch
}

src_configure() {
	econf
		$(use_enable inline) \
		$(use_enable debug) \
		$(use_enable profiling profile) \
		$(use_enable jpeg) \
		$(use_enable png)
}

src_install() {

	if use doc; then
		HTML_DOCS=("${S}/doc/html/")
	fi

	base_src_install

}
