# Distributed under the terms of the GNU General Public License v2

EAPI=4

DESCRIPTION="A small, powerful math library completely written as a C++ template which can be easily integrated into other projects"
HOMEPAGE="http://tinymath.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/Release%20Candidate/rc1-${PN}-0.1/rc1-${PN}-0.1.zip"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples"

DEPEND=""
RDEPEND="${DEPEND}"

S=${WORKDIR}/${PN}

src_install() {
	insinto "${EPREFIX}/usr/include"
	doins -r include/*

	if use examples; then
		insinto "${EPREFIX}/usr/local/src/${PN}"
		doins -r examples
	fi

	dodoc TinyMath.txt doc/*
}
