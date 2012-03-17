# Copyright 2012 Funtoo Technologies
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit autotools eutils subversion

DESCRIPTION="An Enesim library which allows one to describe what properties define a renderer and what properties are shared among different renderers."
HOMEPAGE="http://code.google.com/p/enesim/"
SRC_URI=""
ESVN_REPO_URI="http://enesim.googlecode.com/svn/trunk/ender/"
LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~x86"
IUSE="doc static-libs"

DEPEND="dev-libs/eina
	dev-util/pkgconfig
	media-libs/enesim
	doc? ( app-doc/doxygen )"
RDEPEND="${DEPEND}"

#S="${WORKDIR}/${P}"

src_unpack() {
	subversion_src_unpack
}

src_prepare() {
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable doc) \
		--enable-shared \
		$(use_enable static-libs static)
}
