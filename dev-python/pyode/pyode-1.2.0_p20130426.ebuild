# Distributed under the terms of the GNU General Public License v2

EAPI="5"

PYTHON_COMPAT=( python{2_6,2_7} pypy pypy2_0 )

inherit distutils-r1

COMMIT="dfd6cbbe296560119a08035924ac7826bd0a8a4d"
SNAPSHOT_DATE="2013-04-26"

DESCRIPTION="Python bindings to the ODE physics engine"
HOMEPAGE="http://pyode.sourceforge.net/"
SRC_URI="http://sourceforge.net/code-snapshots/git/p/py/pyode/git.git/pyode-git-dfd6cbbe296560119a08035924ac7826bd0a8a4d.zip -> PyODE-snapshot-${SNAPSHOT_DATE}.zip"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~x86-fbsd"
IUSE="examples"

RDEPEND=">=dev-games/ode-0.7
	>=dev-python/pyrex-0.9.4.1[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}"

S="${WORKDIR}/pyode-git-${COMMIT}"

python_compile() {
	python_is_python3 || local -x CFLAGS="${CFLAGS} -fno-strict-aliasing"
	distutils-r1_python_compile
}

src_install() {
	distutils-r1_src_install

	# The build system doesnt error if it fails to build
	# the ode library so we need our own sanity check
	[[ -n $(find "${D}" -name ode.so) ]] || die "ode.so is missing"

	if use examples; then
		docompress -x /usr/share/doc/${PF}/examples
		insinto /usr/share/doc/${PF}
		doins -r examples
	fi
}
