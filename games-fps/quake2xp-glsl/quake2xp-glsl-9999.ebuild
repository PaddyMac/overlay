# Distributed under the terms of the GNU General Public License v2

EAPI=4

inherit games subversion

MY_PN="quake2xp"

DESCRIPTION="glsl shaders required by Quake2XP"
HOMEPAGE="http://quake2xp.sourceforge.net/"
SRC_URI=""
ESVN_REPO_URI="svn://svn.code.sf.net/p/quake2xp/code/glsl"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+zip"

DEPEND="zip? ( app-arch/zip )"
RDEPEND="~games-fps/quake2xp-9999"

S=${WORKDIR}/glsl

src_install() {

	if use zip; then
		cd ${WORKDIR}
		zip -qr9 q2xpGLSL.pkx glsl
	fi

	if use zip; then
		insinto "${GAMES_DATADIR}"/${MY_PN}/baseq2
		doins "${WORKDIR}"/q2xpGLSL.pkx
	else
		insinto "${GAMES_DATADIR}"/${MY_PN}/baseq2
		cd ${WORKDIR}
		doins -r glsl
	fi

	prepgamesdirs
}
