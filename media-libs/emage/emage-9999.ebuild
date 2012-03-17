# Copyright 2012 Funtoo Technologies
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit autotools eutils subversion

DESCRIPTION="A library for image loader/saver using Enesim's surface abstraction."
HOMEPAGE="http://code.google.com/p/enesim/"
SRC_URI=""
ESVN_REPO_URI="http://enesim.googlecode.com/svn/trunk/emage/"
LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~x86"
IUSE="jpeg +png static-libs"

DEPEND="dev-libs/eina
	dev-util/pkgconfig
	jpg? ( virtual/jpeg )
	png? ( media-libs/libpng )"
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
		$(use_enable jpeg module-jpg) \
		$(use_enable png module-png) \
		--enable-shared \
		$(use_enable static-libs static)
}
