# Copyright 2012 Funtoo Technologies
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
PYTHON_DEPEND="2:2.6:2.7"

inherit distutils subversion python

DESCRIPTION="Generate Your Projects."
HOMEPAGE="http://code.google.com/p/gyp/"
SRC_URI=""
ESVN_REPO_URI="http://gyp.googlecode.com/svn/trunk/"
LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="dev-python/setuptools
	dev-vcs/subversion"
RDEPEND="${DEPEND}
	dev-util/scons"
RESTRICT_PYTHON_ABIS="3.*"

#S="${WORKDIR}/${P}"

src_compile() {
        distutils_src_compile
}

src_install() {
        distutils_src_install
}

DOCS="AUTHORS"
