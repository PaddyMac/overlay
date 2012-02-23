# Copyright 2012 Funtoo Technologies
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit eutils cmake-utils games

DESCRIPTION="An open source reimplementation of the role playing game The Elder Scrolls III: Morrowind."
HOMEPAGE="http://openmw.org/"
SRC_URI="http://openmw.googlecode.com/files/${P}-source.tar.bz2"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86"
IUSE="audiere debug ffmpeg +mpg123"

DEPEND=">=dev-games/ogre-1.7.0
	dev-games/ois
	>=dev-libs/boost-1.45.0
	dev-util/pkgconfig
	sci-physics/bullet
	audiere? ( media-libs/audiere )
	ffmpeg? ( media-video/ffmpeg )
	mpg123? ( media-sound/mpg123
		media-libs/libsndfile )"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${P}-source"

src_configure() {

	if use debug; then
		CMAKE_BUILD_TYPE=Debug
	else
		CMAKE_BUILD_TYPE=Release
	fi

        # Hard set options.
	local mycmakeargs=(
		"-DCMAKE_C_FLAGS_DEBUG:STRING=${CFLAGS}"
		"-DCMAKE_C_FLAGS_RELEASE:STRING=${CFLAGS} -DNDEBUG"
		"-DCMAKE_CXX_FLAGS_DEBUG:STRING=${CXXFLAGS}"
		"-DCMAKE_CXX_FLAGS_RELEASE:STRING=${CXXFLAGS} -DNDEBUG"
		"-DCMAKE_EXE_LINKER_FLAGS_DEBUG:STRING=${LDFLAGS}"
		"-DCMAKE_EXE_LINKER_FLAGS_RELEASE:STRING=${LDFLAGS}"
		"-DCMAKE_MODULE_LINKER_FLAGS_DEBUG:STRING=${LDFLAGS}"
		"-DCMAKE_MODULE_LINKER_FLAGS_RELEASE:STRING=${LDFLAGS}"
		"-DCMAKE_SHARED_LINKER_FLAGS_DEBUG:STRING=${LDFLAGS}"
		"-DCMAKE_SHARED_LINKER_FLAGS_RELEASE:STRING=${LDFLAGS}"
	)

	# Use cmake-utils to set options according to use flags.
	mycmakeargs+=(
		$(cmake-utils_use audiere USE_AUDIERE)
		$(cmake-utils_use debug CMAKE_EXPORT_COMPILE_COMMANDS)
		$(cmake-utils_use ffmpeg USE_FFMPEG)
		$(cmake-utils_use mpg123 USE_MPG123)
	)

	cmake-utils_src_configure

}

src_compile() {
	cmake-utils_src_compile
}

src_install() {

	DOCS="readme.txt README_Mac.md"

	cmake-utils_src_install

	prepgamesdirs
}
