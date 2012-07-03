# Copyright 2012 Funtoo Technologies
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit eutils cmake-utils

DESCRIPTION="Real-time rendering of massive, dense forests, with not only trees, but bushes, grass, rocks, and other "clutter"."
HOMEPAGE="http://code.google.com/p/ogre-paged/"
SRC_URI="http://ogre-paged.googlecode.com/files/${P}.tar.gz"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="alternate_coordsystem doc samples use_ogre_random user_data"

DEPEND=">=dev-games/ogre-1.6
	doc? ( app-doc/doxygen )"
RDEPEND="${DEPEND}"

#S=${WORKDIR}/${P}

src_prepare() {

	epatch "${FILESDIR}"/${P}-docdir.patch
}

src_configure() {

	mycmakeargs=(
		$(cmake-utils_use alternate_coordsystem PAGEDGEOMETRY_ALTERNATE_COORDSYSTEM)
		$(cmake-utils_use samples PAGEDGEOMETRY_BUILD_SAMPLES)
		$(cmake-utils_use use_ogre_random PAGEDGEOMETRY_USE_OGRE_RANDOM)
		$(cmake-utils_use user_data PAGEDGEOMETRY_USER_DATA)
	)

	if use !doc; then
		mycmakeargs+=(
			"-DDOXYGEN_EXECUTABLE:FILEPATH=DOXYGEN_EXECUTABLE-NOTFOUND"
		)
	fi

	cmake-utils_src_configure

}

src_compile() {
	cmake-utils_src_compile
}

src_install() {
	cmake-utils_src_install
}
