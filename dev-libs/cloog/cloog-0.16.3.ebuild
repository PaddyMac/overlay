# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/cloog/cloog-0.17.0.ebuild,v 1.1 2012/02/20 06:46:16 dirtyepic Exp $

EAPI="3"

inherit autotools-utils

DESCRIPTION="A loop generator for scanning polyhedra"
HOMEPAGE="http://www.bastoul.net/cloog/index.php"
SRC_URI="http://www.bastoul.net/cloog/pages/download/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="static-libs"

DEPEND="dev-libs/gmp
	<=dev-libs/isl-0.07-r1
	!<dev-libs/cloog-ppl-0.15.10"
RDEPEND="${DEPEND}"

DOCS=( README doc/cloog.pdf )

src_configure() {
	myeconfargs=(
		--with-isl=system
	)
	autotools-utils_src_configure
}
