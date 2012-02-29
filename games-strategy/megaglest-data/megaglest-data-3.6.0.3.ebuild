# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
inherit eutils cmake-utils games

MY_PN="megaglest"
MY_GAMES_BINDIR="${GAMES_BINDIR#/usr/}"
MY_GAMES_DATADIR="${GAMES_DATADIR#/usr/}"
DESCRIPTION="Data files for the cross-platform 3D realtime strategy game MegaGlest"
HOMEPAGE="http://www.megaglest.org/"
SRC_URI="mirror://sourceforge/${MY_PN}/${PN}-${PV}.tar.xz"

LICENSE="CCPL-Attribution-ShareAlike-3.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

DEPEND="app-arch/xz-utils"
RDEPEND=""
PDEPEND=">=games-strategy/megaglest-${PV}"

S=${WORKDIR}/${MY_PN}-${PV}

pkg_setup() {
        games_pkg_setup
}

src_prepare() {
	# This patches CMakeLists.txt to ensure that all necessary .ico and .ini files are installed
	# and prevents the .html documentation from being automatically installed.
	epatch "${FILESDIR}"/${P}-CMakeLists.txt.patch
}

src_configure() {

	mycmakeargs=(
		"-DMEGAGLEST_BIN_INSTALL_PATH:STRING=${MY_GAMES_BINDIR}"
		"-DMEGAGLEST_DATA_INSTALL_PATH:STRING=${MY_GAMES_DATADIR}/${MY_PN}"
		"-DMEGAGLEST_ICON_INSTALL_PATH:STRING=/usr/share/pixmaps"
	)
	cmake-utils_src_configure
}

src_compile() {
        cmake-utils_src_compile
}

src_install() {
	
	DOCS="docs/AUTHORS.data.txt docs/CHANGELOG.txt docs/README.txt"

	if use doc; then
		HTML_DOCS="docs/glest_factions/"
	fi

	cmake-utils_src_install

	prepgamesdirs

}
