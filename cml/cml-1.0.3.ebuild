# Distributed under the terms of the GNU General Public License v2

EAPI=4

inherit versionator

MY_PV="$(replace_all_version_separators _ )"

DESCRIPTION="Configurable Math Library is a free, open-source C++ vector, matrix, and quaternion math library designed for use in games, graphics, computational geometry, and related applications."
HOMEPAGE="www.cmldev.net"
SRC_URI="mirror://sourceforge/cmldev/CML%201.0/${PN}-${MY_PV}.zip"

LICENSE="Boost-1.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples"

DEPEND=""
RDEPEND="${DEPEND}"

S=${WORKDIR}/${PN}-${MY_PV}

src_install() {
	insinto ${EPREFIX}/usr/include
	doins -r cml
	dodoc doc/*
	if use examples; then
		insinto ${EPREFIX}/usr/local/src/${PN}
		doins examples/*
	fi
}
