# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit eutils cmake-utils subversion

MY_PN="Fog"

DESCRIPTION="Fog-Framework - High performance 2d vector painting, SVG, and UI written in C++"
HOMEPAGE="http://code.google.com/p/fog/"
SRC_URI=""
ESVN_REPO_URI="http://fog.googlecode.com/svn/trunk/Fog/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~x86"
IUSE="3dnow c++0x examples mmx nothing slave sse sse2 sse3 static-libs tools +ui +X"
#RESTRICT="strip"

# Only pthreads, libdl, and librt are required to be linked on Linux.
DEPEND=""
RDEPEND="${DEPEND}
	media-libs/fontconfig
	media-libs/freetype
	media-libs/jpeg
	media-libs/libpng
	x11-libs/libX11"

S="${WORKDIR}/${P}/${MY_PN}"

src_unpack() {
        subversion_src_unpack
}

src_configure() {

	local mycmakeargs=(
		$(cmake-utils_use 3dnow FOG_OPTIMIZE_3DNOW)
		$(cmake-utils_use c++0x FOG_CC_HAS_CPP0X)
		$(cmake-utils_use examples FOG_BUILD_EXAMPLES)
		$(cmake-utils_use mmx FOG_OPTIMIZE_MMX)
		$(cmake-utils_use nothing FOG_BUILD_NOTHING)
		$(cmake-utils_use slave FOG_BUILD_SLAVE)
		$(cmake-utils_use sse FOG_OPTIMIZE_SSE)
		$(cmake-utils_use sse2 FOG_OPTIMIZE_SSE2)
		$(cmake-utils_use sse3 FOG_OPTIMIZE_SSE3)
		$(cmake-utils_use static-libs FOG_BUILD_STATIC)
		$(cmake-utils_use tools FOG_BUILD_BENCH)
		$(cmake-utils_use ui FOG_BUILD_UI)
		$(cmake-utils_use X FOG_BUILD_UI_X11)
		$(cmake-utils_use X FOG_BUILD_UI_X11_MODULE)
	)

	cmake-utils_src_configure
}
