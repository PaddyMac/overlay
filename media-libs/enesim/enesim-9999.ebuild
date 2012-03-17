# Copyright 2012 Funtoo Technologies
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit autotools eutils subversion

DESCRIPTION="Graphics framework focused on flexibility and extensibility"
HOMEPAGE="http://code.google.com/p/enesim/"
SRC_URI=""
ESVN_REPO_URI="http://enesim.googlecode.com/svn/trunk/enesim/"
LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~x86"
IUSE="altivec +argb8888_unpre benchmark coverage equanime mmx pthreads +rgb565_b1a3 rgb565_xa5 rgb888 rgb888_a8 sse sse2 static-libs test" # opencl opengl

DEPEND="dev-libs/eina
	dev-util/pkgconfig"
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
		$(use_enable argb8888_unpre format-argb8888_unpre) \
		$(use_enable benchmark) \
		$(use_enable coverage) \
		$(use_with   equanime) \
		$(use_enable mmx cpu-mmx) \
		$(use_enable pthreads) \
		$(use_enable rgb565_b1a3 format-rgb565_b1a3) \
		$(use_enable rgb565_xa5 format-rgb565_xa5) \
		$(use_enable rgb888 format-rgb888) \
		$(use_enable rgb888_a8 format-rgb888_a8) \
		$(use_enable sse cpu-sse) \
		$(use_enable sse2 cpu-sse2) \
		--enable-shared
		$(use_enable static-libs static)
		$(use_enable test tests)
}
