# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit games

DESCRIPTION="Duke Nukem 3D 1.3d shareware data"
HOMEPAGE="http://www.3drealms.com/duke3d/"
SRC_URI="ftp://ftp.3drealms.com/share/3dduke13.zip"

LICENSE="DUKE3D"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="app-arch/unzip
	!games-fps/duke3d-data"
RDEPEND=""

S=${WORKDIR}

src_unpack() {
	unpack ${A}
	rm LICENSE.TXT
	unzip DN3DSW13.SHR
}

src_install() {
	insinto "${GAMES_DATADIR}"/duke3d

	mv DEFS.CON defs.con
	mv DEMO1.DMO demo1.dmo
	mv DEMO2.DMO demo2.dmo
	mv DEMO3.DMO demo3.dmo
	mv DUKE.RTS duke.rts
	mv DUKE3D.GRP duke3d.grp
	mv GAME.CON game.con
	mv MODEM.PCK modem.pck
	mv ULTRAMID.INI ultramid.ini
	mv USER.CON user.con

	doins defs.con demo1.dmo demo2.dmo demo3.dmo duke.rts duke3d.grp game.con modem.pck ultramid.ini user.con

	dodoc FILE_ID.DIZ README.DOC

	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst
	echo
	einfo "Please note that many addons for Duke Nukem 3D require the registered version"
	einfo "and will not work with this shareware version."
	echo
}
