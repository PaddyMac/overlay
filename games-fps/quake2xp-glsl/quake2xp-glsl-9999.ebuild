# Distributed under the terms of the GNU General Public License v2

EAPI=4

inherit games subversion

DESCRIPTION="glsl shaders required by Quake2XP"
HOMEPAGE="http://quake2xp.sourceforge.net/"
SRC_URI=""
ESVN_REPO_URI="svn://svn.code.sf.net/p/quake2xp/code/glsl"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="~games-fps/quake2xp-9999"

src_install() {
	insinto "${GAMES_DATADIR}"/${PN}/baseq2/glsl
	doins -r *
	prepgamesdirs
}
