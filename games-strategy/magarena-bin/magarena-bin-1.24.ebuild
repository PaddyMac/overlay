# Copyright 2008-2012 Funtoo Technologies
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit games

MY_PN="Magarena"

DESCRIPTION="A single-player fantasy card game inspired by Magic: The Gathering"
HOMEPAGE="http://code.google.com/p/magarena/"
SRC_URI="http://magarena.googlecode.com/files/${MY_PN}-${PV}.zip"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="virtual/jre"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_PN}-${PV}"

src_install() {
	exeinto "${GAMES_PREFIX_OPT}/${MY_PN}"
	insinto "${GAMES_PREFIX_OPT}/${MY_PN}"
	doins -r Magarena
	doins Magarena.exe || die
	doexe Magarena.sh || die
	dodoc README.txt
	cp Magarena/avatars/legend/avatar01.png Magarena.png
	doicon Magarena.png
	games_make_wrapper "magarena" "./Magarena.sh" "/opt/Magarena"
	make_desktop_entry "${MY_PN}" "${MY_PN}" "${MY_PN}" "Game;StrategyGame;"
	prepgamesdirs
}
