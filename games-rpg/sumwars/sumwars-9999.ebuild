# Copyright 2012 Funtoo Technologies
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit eutils games versionator cmake-utils mercurial

MY_GAMES_BINDIR="${GAMES_BINDIR#/usr/}"
MY_GAMES_DATADIR="${GAMES_DATADIR#/usr/}"
MY_PV=$(replace_all_version_separators '-')
DESCRIPTION="open source role-playing game featuring both a single-player and a multiplayer mode for about 2 to 8 players"

HOMEPAGE="http://sumwars.org/"

#SRC_URI="mirror://sourceforge/${PN}/${PN}_${MY_PV}_src.tgz"
EHG_REPO_URI="https://bitbucket.org/sumwars/sumwars-code"

LICENSE="GPL-3"

SLOT="0"

KEYWORDS="~amd64 ~x86"

IUSE="debug +noenet +notinyxml +randomregions tools"

DEPEND="noenet? ( net-libs/enet )
	notinyxml? ( dev-libs/tinyxml )
	>=dev-games/ogre-1.7
	<dev-games/ogre-1.8
	dev-games/ois
	dev-games/physfs
	>=dev-games/cegui-0.7
	>=dev-util/cmake-2.6
	media-libs/freealut
	media-libs/openal
	=dev-lang/lua-5.1*
	media-libs/libogg
	media-libs/libvorbis"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}"

src_unpack() {
	mercurial_src_unpack
}

#src_prepare() {
#	epatch "${FILESDIR}/${P}-CMakeLists.txt.patch"
#	epatch "${FILESDIR}/${P}-desktop.patch"
#}

src_configure() {

# Determine build type
	if use debug; then
		CMAKE_BUILD_TYPE=Debug
	else
		CMAKE_BUILD_TYPE=Release
	fi

	# Configure cmake
	local mycmakeargs=(
		"-DCMAKE_INSTALL_PREFIX=/usr"
		"-DSUMWARS_DOC_DIR=share/doc/${P}"
		"-DSUMWARS_EXECUTABLE_DIR=MY_GAMES_BINDIR}"
		"-DSUMWARS_PORTABLE_MODE=OFF"
		"-DSUMWARS_POST_BUILD_COPY=OFF"
		"-DSUMWARS_SHARE_DIR=${MY_GAMES_DATADIR}/${PN}"
		"-DSUMWARS_STANDALONE_MODE=OFF"
		"-DSUMWARS_UPDATE_HG_REVISION=ON"
		$(cmake-utils_use noenet SUMWARS_NO_ENET)
		$(cmake-utils_use notinyxml SUMWARS_NO_TINYXML)
		$(cmake-utils_use randomregions SUMWARS_RANDOM_REGIONS)
		$(cmake-utils_use tools SUMWARS_BUILD_TOOLS)
	)
		
	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
}

src_install() {

	DOCS="README"

	cmake-utils_src_install

	prepgamesdirs
}
