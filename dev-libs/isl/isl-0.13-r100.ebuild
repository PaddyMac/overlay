# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit eutils

DESCRIPTION="A library for manipulating integer points bounded by affine constraints"
HOMEPAGE="http://freecode.com/projects/isl"
SRC_URI="http://isl.gforge.inria.fr/${P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~mips ~x86 ~amd64-fbsd ~x86-fbsd"
IUSE="piplib static-libs"

RDEPEND="dev-libs/gmp"
DEPEND="${RDEPEND}
	piplib? ( dev-libs/piplib )"

DOCS=( ChangeLog AUTHORS doc/manual.pdf )

src_prepare() {
	epatch "${FILESDIR}"/${PN}-0.07-gdb-autoload-dir.patch

	# m4/ax_create_pkgconfig_info.m4 is broken but avoid eautoreconf
	# http://groups.google.com/group/isl-development/t/37ad876557e50f2c
	sed -i -e '/Libs:/s:@LDFLAGS@ ::' configure || die #382737
}

src_configure() {
	econf \
		$(usex piplib "--with-piplib=system" "--with-piplib=no") \
		$(use_enable static-libs static)
}

src_install() {
	default
	prune_libtool_files
}
