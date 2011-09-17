# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit eutils games versionator cmake-utils

MY_PV=$(replace_all_version_separators '-')
DESCRIPTION="open source role-playing game featuring both a single-player and a multiplayer mode for about 2 to 8 players"

HOMEPAGE="http://sumwars.org/"

SRC_URI="mirror://sourceforge/${PN}/${PN}_${MY_PV}_src.tgz"

LICENSE="GPL-3"

SLOT="0"

KEYWORDS="~amd64 ~x86"

IUSE="debug"

DEPEND=">=dev-games/ogre-1.7
	dev-games/ois
	>=dev-games/cegui-0.7[ogre]
	>=dev-util/cmake-2.6
	media-libs/freealut
	media-libs/openal
	=dev-lang/lua-5.1*
	media-libs/libogg
	media-libs/libvorbis"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}_${MY_PV}_src"

src_configure() {
	# Determine build type
	if use debug; then
		CMAKE_BUILD_TYPE=Debug
	fi
	
	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
}

src_install() {
	# Install binary
	newgamesbin ${WORKDIR}/${P}_build/${PN} ${PN}.bin || die "dogamesbin failed"

	# Install wrapper script to execute binary
	dogamesbin "${FILESDIR}/${PN}"

	# Initialize installation directory
	insinto "${GAMES_DATADIR}/${PN}"

	# Install data and config files
	doins -r data lib resources translation authors.txt plugins.cfg resources.cfg || die "doins failed"

	# Install documentation
	dodoc AUTHORS README

	# Install an icon
	doicon resources/itempictures/sword.png || die "doicon failed"

	# Creatue desktop menu entry
	make_desktop_entry "${GAMES_BINDIR}/${PN}" "Summoning Wars" "sword" "Game;RolePlaying" "Path=~/.${PN}"

	prepgamesdirs
}
