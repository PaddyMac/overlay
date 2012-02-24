# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit eutils games cmake-utils

DESCRIPTION="open source role-playing game featuring both a single-player and a multiplayer mode for about 2 to 8 players"

HOMEPAGE="http://sumwars.org/"

SRC_URI="mirror://sourceforge/${PN}/${PN}-${PV}-src.tgz"

LICENSE="GPL-3"

SLOT="0"

KEYWORDS="~amd64 ~x86"

IUSE="debug"

DEPEND="debug? ( dev-libs/poco )
	>=dev-games/ogre-1.7.3
	<dev-games/ogre-1.8
	dev-games/ois
	dev-games/physfs
	>=dev-games/cegui-0.7.5[ogre]
	>=dev-util/cmake-2.6
	media-libs/freealut
	media-libs/openal
	=dev-lang/lua-5.1*
	media-libs/libogg
	media-libs/libvorbis"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${P}-src"

# Determine build type
        if use debug; then
                CMAKE_BUILD_TYPE=Debug
        else
                CMAKE_BUILD_TYPE=Release
        fi

src_prepare() {

	epatch "${FILESDIR}"/${P}-CMakeLists.txt.patch
	epatch "${FILESDIR}"/${P}-desktop.patch
}

src_configure() {
        # Configure cmake
        mycmakeargs="
                -DCMAKE_INSTALL_PREFIX=/usr"
	
	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
}

src_install() {

	DOCS="README"

	cmake-utils_src_install

	# Install wrapper script to execute binary
	dogamesbin "${FILESDIR}/${PN}"

	prepgamesdirs
}
