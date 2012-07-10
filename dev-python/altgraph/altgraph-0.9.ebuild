# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
inherit distutils

DESCRIPTION="fork of graphlib: a graph (network) package for constructing graphs, BFS and DFS traversals, topological sort, shortest paths, etc. with graphviz output."
HOMEPAGE="http://pypi.python.org/pypi/altgraph/"
SRC_URI="http://pypi.python.org/packages/source/a/altgraph/altgraph-0.9.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
DEPEND="dev-python/setuptools"
RDEPEND="${DEPEND}"

src_compile() {
	distutils_src_compile
}
        
src_install() {
	distutils_src_install
}
                                        
DOCS="PKG-INFO README.txt doc/*.rst"
