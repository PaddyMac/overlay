# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit eutils

DESCRIPTION="A loop generator for scanning polyhedra"
HOMEPAGE="http://www.bastoul.net/cloog/index.php"
SRC_URI="http://www.bastoul.net/cloog/pages/download/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~mips ~x86 ~amd64-fbsd ~x86-fbsd"
IUSE="osl static-libs"

DEPEND="dev-libs/gmp
	>=dev-libs/isl-0.12.1
	!<dev-libs/cloog-ppl-0.15.10
	osl? ( dev-libs/osl )"
RDEPEND="${DEPEND}"

DOCS=( README )

src_prepare() {
	# m4/ax_create_pkgconfig_info.m4 includes LDFLAGS
	# sed to avoid eautoreconf
	sed -i -e '/Libs:/s:@LDFLAGS@ ::' configure || die
}

src_configure() {
	econf \
		--with-gmp=system \
		--with-isl=system \
		$(usex osl "--with-osl=system" "--with-osl=no") \
		$(use_enable static-libs static)
}

src_install() {
	default
	prune_libtool_files
}
