# Distributed under the terms of the GNU General Public License v2

EAPI=4-python
PYTHON_DEPEND="<<2:2.6>>"

inherit git-2

DESCRIPTION="An implementation of the library requirements of the OpenCL C programming language, as specified by the OpenCL 1.1 Specification."
HOMEPAGE="http://libclc.llvm.org/ http://dri.freedesktop.org/wiki/GalliumCompute"
SRC_URI=""
EGIT_REPO_URI="git://people.freedesktop.org/~tstellar/libclc"

# See LICENSE.TXT for specifics
LICENSE="|| ( MIT UoI-NCSA )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND=""

src_configure() {
	# The configure script requires Python2 and will not work with Python3
	./configure.py --prefix=${EPREFIX}/usr
}

src_install() {
	default
	# We do need to install LICENSE.TXT to explain how the two different licenses apply.
	dodoc CREDITS.TXT LICENSE.TXT README.TXT
}
