# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/soya/soya-0.14.ebuild,v 1.8 2012/02/27 14:50:16 patrick Exp $

EAPI="3"
PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.* *-jython 2.7-pypy-*"

inherit distutils eutils

MY_PN="Soya"
MY_PV="${PV/_}"
MY_P="Soya-${MY_PV}"
TUT_P="SoyaTutorial-0.14"

DESCRIPTION="A high-level 3D engine for Python, designed with games in mind"
HOMEPAGE="http://home.gna.org/oomadness/en/soya3d/index.html"
SRC_URI="http://download.gna.org/soya/${MY_P}.tar.bz2
	doc? ( http://download.gna.org/soya/${TUT_P}.tar.bz2 )
	examples? ( http://download.gna.org/soya/${TUT_P}.tar.bz2 )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="doc examples"

DEPEND=">=dev-games/ode-0.10[-double-precision]
	dev-python/editobj
	>=dev-python/pyopenal-0.1.6
	media-fonts/freefonts
	>=media-libs/cal3d-0.10
	media-libs/freeglut
	>=media-libs/freetype-2.1.5
	>=media-libs/glew-1.3.3
	>=media-libs/libsdl-1.2.8[opengl]
	media-libs/openal
	virtual/opengl
	virtual/python-imaging"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_PN}"

PYTHON_CFLAGS=("2.* + -fno-strict-aliasing")

src_unpack() {
	if [ "${A}" != "" ]; then
		unpack ${A}
	fi

	mv "${WORKDIR}/${MY_P}" "${WORKDIR}/${MY_PN}"
}


src_prepare() {
	distutils_src_prepare
	epatch "${FILESDIR}/${P}-glu.patch"
}

src_install() {
	distutils_src_install

	insinto /usr/share/${PF}
	if use doc; then
		cd "${WORKDIR}/${TUT_P}/doc"
		doins soya_guide.pdf pudding/pudding.pdf || die "doins failed"
	fi
	if use examples; then
		cd "${WORKDIR}/${TUT_P}"
		doins -r tutorial || die "doins failed"
	fi
}
