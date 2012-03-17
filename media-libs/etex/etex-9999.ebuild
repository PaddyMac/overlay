# Copyright 2012 Funtoo Technologies
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit autotools eutils subversion

DESCRIPTION="A library that provides an Enesim Renderer for drawing text."
HOMEPAGE="http://code.google.com/p/enesim/"
SRC_URI=""
ESVN_REPO_URI="http://enesim.googlecode.com/svn/trunk/etex/"
LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~x86"
IUSE="altivec doc mmx sse sse2 static-libs"

DEPEND="dev-libs/eina
	dev-util/pkgconfig
	media-libs/freetype
	media-libs/emage
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
		$(use_enable altivec cpu-altivec) \
		$(use_enable doc) \
		$(use_enable mmx cpu-mmx) \
		$(use_enable sse cpu-sse) \
		$(use_enable sse2 cpu-sse2) \
		--enable-shared \
		$(use_enable static-libs static)
}
