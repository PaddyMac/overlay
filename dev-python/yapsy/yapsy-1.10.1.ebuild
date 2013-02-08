# Distributed under the terms of the GNU General Public License v2

EAPI=4-python

PYTHON_MULTIPLE_ABIS=1
DISTUTILS_SRC_TEST="setup.py"

inherit distutils

MY_PN="Yapsy"

DESCRIPTION="Yet Another Plugin System: A simple plugin system for Python applications."
HOMEPAGE="http://yapsy.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${MY_PN}-${PV}/${MY_PN}-${PV}-pythons2n3.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

DEPEND="dev-python/setuptools
	doc? ( dev-python/sphinx )"
RDEPEND=""

S="${WORKDIR}/${MY_PN}-${PV}-pythons2n3"

src_compile() {
	distutils_src_compile

	if use doc; then
		emake -C src2/package/doc html
	fi
}

src_install() {
	distutils_src_install

	doicon src2/package/artwork/yapsy.svg

	if use doc; then
		dohtml -r src2/package/doc/_build/html/
	fi
}
