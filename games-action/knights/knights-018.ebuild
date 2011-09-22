# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit eutils games

DESCRIPTION="multiplayer game involving several knights who must run around a dungeon and complete various quests"
HOMEPAGE="http://www.knightsgame.org.uk/"
SRC_URI="http://www.knightsgame.org.uk/files/${PN}_${PV}_src.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc +game server"

S=${WORKDIR}/${PN}_${PV}_src

DEPEND="dev-libs/boost
		media-libs/libsdl
		game? ( media-libs/fontconfig
			media-libs/freetype
			( || ( net-misc/curl[gnutls] net-misc/curl[ssl] ) ) )"
RDEPEND="${DEPEND}"

#src_prepare() {
#	sed -i "s:PREFIX = /usr/local:PREFIX = /usr:" Makefile || die "sed PREFIX failed"
#	sed -i "s:BIN_DIR = \$(PREFIX)/bin:BIN_DIR = \$(PREFIX)/games/bin:" Makefile || die "sed BIN_DIR failed"
#	sed -i "s:DOC_DIR = \$(PREFIX)/share/doc/knights:DOC_DIR = \$(PREFIX)/share/doc/knights-${PV}:" Makefile || die "sed DOC_DIR failed"
#	sed -i "s:DATA_DIR = \$(PREFIX)/share/knights:DATA_DIR = \$(PREFIX)/share/games/knights:" Makefile || die "sed DATA_DIR failed"
#}

src_compile() {
	emake PREFIX=${D} BIN_DIR="${GAMES_BINDIR}" DATA_DIR="${GAMES_DATADIR}"/"${PN}" DOC_DIR=/usr/share/doc/"${P}"
}

src_install() {

	if use game; then
		emake install_knights PREFIX=${D} BIN_DIR="${D}/${GAMES_BINDIR}" DATA_DIR="${D}/${GAMES_DATADIR}/${PN}" DOC_DIR="${D}"/usr/share/doc/"${P}"
	fi

	if use server; then
		emake install_server PREFIX=${D} BIN_DIR="${D}/${GAMES_BINDIR}" DATA_DIR="${D}/${GAMES_DATADIR}/${PN}" DOC_DIR="${D}"/usr/share/doc/"${P}"
	fi

#
#	# The .txt and .lua files are required by both the game and server, so we'll install them first.
#	insinto "${GAMES_DATADIR}"/${PN}/${PN}_data
#		doins ${PN}_data/*.{txt,lua} || die "doins .txt failed"
#
#	if use game; then
#		dogamesbin ${PN} || die "dogamesbin ${PN} failed"
#		insinto "${GAMES_DATADIR}"/${PN}/${PN}_data
#		doins ${PN}_data/*.{bmp,wav} || die "doins .bmp failed"
#	fi
#
#	if use server; then
#		dogamesbin ${PN}_server || die "dogamesbin ${PN}_server failed"
#	fi

	if use doc; then
		dohtml -r docs/manual || die "dohtml failed"
		dohtml docs/style_new.css || die "dohtml failed"
	fi

	dodoc docs/ACKNOWLEDGMENTS.txt docs/CHANGELOG.txt docs/README.txt README.txt docs/third_party_licences/README.txt || die "dodoc failed"

	doicon docs/manual/images/pentagram.png
	make_desktop_entry knights "Knights" pentagram "Games;ActionGame;"
	make_desktop_entry knights_server "Knights server" pentagram "Games;ActionGame;"

	prepgamesdirs
}
