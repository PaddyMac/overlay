# Distributed under the terms of the GNU General Public License v2

EAPI=4

inherit games subversion

DESCRIPTION="Quake2World game data"
HOMEPAGE="http://quake2world.net/"
SRC_URI=""
ESVN_REPO_URI="svn://quake2world.net/quake2world-data/trunk"

LICENSE="CC0-1.0-Universal CCPL-Attribution-2.0 CCPL-Attribution-2.5
	CCPL-Attribution-3.0 CCPL-Attribution-NoDerivs-2.5 
	CCPL-Attribution-NoDerivs-3.0 CCPL-Attribution-NonCommercial-2.5
	CCPL-Attribution-NonCommercial-NoDerivs-2.0
	CCPL-Attribution-NonCommercial-NoDerivs-2.5 
	CCPL-Attribution-NonCommercial-ShareAlike-2.5 
	CCPL-Attribution-NonCommercial-ShareAlike-3.0 
	CCPL-Attribution-ShareAlike-2.0 CCPL-Attribution-ShareAlike-2.5 
	CCPL-Attribution-ShareAlike-3.0 CCPL-Attribution-ShareAlike-NonCommercial-2.5
	CCPL-Attribution-ShareAlike-NonCommercial-3.0 CCPL-Sampling-Plus-1.0
	CCPL-ShareAlike-1.0 GPL MIT WTFPL-2 ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="games-fps/quake2world"

src_install() {
	dodir ${GAMES_DATADIR}/quake2world
	cp -r target/* ${D}/${GAMES_DATADIR}/quake2world
	prepgamesdirs
}
