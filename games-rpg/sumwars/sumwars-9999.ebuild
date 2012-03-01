# Copyright 2012 Funtoo Technologies
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit eutils games flag-o-matic cmake-utils mercurial

MY_GAMES_BINDIR="${GAMES_BINDIR#/usr/}"
MY_GAMES_DATADIR="${GAMES_DATADIR#/usr/}"

DESCRIPTION="a multi-player, 3D action role-playing game"
HOMEPAGE="http://sumwars.org/"
EHG_REPO_URI="https://bitbucket.org/sumwars/sumwars-code"
LICENSE="GPL-3 CC-BY-SA-v3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+enet +tinyxml +randomregions +stl tools"

LANGS="de en it pl pt ru uk"
for L in ${LANGS} ; do
	IUSE="${IUSE} linguas_${L}"
done

DEPEND="enet? ( =net-libs/enet-1.3* )
	tinyxml? ( dev-libs/tinyxml[stl=] )
	=dev-games/ogre-1.7*
	dev-games/ois
	dev-games/physfs
	=dev-games/cegui-0.7*[ogre]
	>=dev-util/cmake-2.6
	media-libs/freealut
	media-libs/openal
	=dev-lang/lua-5.1*
	media-libs/libogg
	media-libs/libvorbis
	x11-libs/libX11
	x11-libs/libXext"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}"

src_unpack() {
	mercurial_src_unpack
}

src_prepare() {
	epatch "${FILESDIR}/${P}-CMakeLists.txt.patch"
	epatch "${FILESDIR}/${P}-desktop.patch"
}

src_configure() {

	strip-linguas ${LANGS}
	use stl && append-cppflags -DTIXML_USE_STL

	# Hard set options
	local mycmakeargs=(
		"-DSUMWARS_DOC_DIR=share/doc/${P}"
		"-DSUMWARS_EXECUTABLE_DIR=${MY_GAMES_BINDIR}"
		"-DSUMWARS_LANGUAGES=${LINGUAS}"
		"-DSUMWARS_PORTABLE_MODE=OFF"
		"-DSUMWARS_POST_BUILD_COPY=OFF"
		"-DSUMWARS_SHARE_DIR=${MY_GAMES_DATADIR}/${PN}"
		"-DSUMWARS_STANDALONE_MODE=OFF"
		"-DSUMWARS_UPDATE_HG_REVISION=ON"
	)

	# Options controlled by use flags
	mycmakeargs+=(
		$(cmake-utils_use enet SUMWARS_NO_ENET)
		$(cmake-utils_use tinyxml SUMWARS_NO_TINYXML)
		$(cmake-utils_use randomregions SUMWARS_RANDOM_REGIONS)
		$(cmake-utils_use tools SUMWARS_BUILD_TOOLS)
	)

	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
}

src_install() {
	cmake-utils_src_install
	prepgamesdirs
}
