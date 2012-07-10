# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
inherit distutils

DESCRIPTION="creates stand-alone executables from python scripts"
HOMEPAGE="http://pypi.python.org/pypi/bbfreeze/"
SRC_URI="http://pypi.python.org/packages/source/b/bbfreeze/bbfreeze-1.0.0.zip"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
DEPEND="dev-python/setuptools"
RDEPEND="${DEPEND}"
RESTRICT_PYTHON_ABIS="3.*"

src_compile() {
	distutils_src_compile
}
        
src_install() {
	distutils_src_install
}
                                        
DOCS="PKG-INFO README.rst"
