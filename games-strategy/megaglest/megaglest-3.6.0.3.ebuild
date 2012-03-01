# Copyright 2012 Funtoo Technologies
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
inherit eutils cmake-utils wxwidgets games

MY_GAMES_BINDIR="${GAMES_BINDIR#/usr/}"
MY_GAMES_DATADIR="${GAMES_DATADIR#/usr/}"
DESCRIPTION="Cross-platform 3D realtime strategy game"
HOMEPAGE="http://www.megaglest.org/"

SRC_URI="mirror://sourceforge/${PN}/${PN}-source-${PV}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+configurator curl_dynamic debug +editor freetype +ftgl +libircclient +manpages +miniupnpc sse sse2 sse3 static-libs +streflop +tools +unicode universal +viewer"

# MegaGlest configuration script will only attempt to locate an external libircclient or miniupnpc if -DWANT_STATIC_LIBS="off"
# If static-libs is off and an external copy is not present, it will use an embedded libircclient or miniupnpc.
# It will ALWAYS use embedded versions of these libraries if static-libs is enabled.

DEPEND="app-arch/p7zip
	app-arch/xz-utils
	>=dev-util/cmake-2.8
	>=dev-lang/lua-5.1
	dev-libs/icu
	dev-libs/libxml2
	>=dev-libs/xerces-c-3
	media-libs/fontconfig
	freetype? ( media-libs/freetype )
	ftgl? ( media-libs/ftgl )
	media-libs/glew
	>=media-libs/libsdl-1.2.5[audio,joystick,video]
	media-libs/libogg
	>=media-libs/libpng-1.4
	media-libs/libvorbis
	media-libs/openal
	net-libs/gnutls
	libircclient? ( !static-libs? ( >=net-libs/libircclient-1.6 ) )
	>=net-misc/curl-7.21.0
	miniupnpc? ( !static-libs? ( >=net-libs/miniupnpc-1.6-r1 ) )
	manpages? ( sys-apps/help2man )
	sys-libs/zlib
	virtual/jpeg
	virtual/opengl
	virtual/glu
	x11-libs/libX11
	x11-libs/libXext
	configurator? ( x11-libs/wxGTK:2.8[X] )
	editor? ( x11-libs/wxGTK:2.8[X] )
	viewer? ( x11-libs/wxGTK:2.8[X] )"
RDEPEND="${DEPEND}
	=games-strategy/megaglest-data-${PV}"

S=${WORKDIR}/${PN}-${PV}

pkg_setup() {
	games_pkg_setup

	if ( use !configurator || use !editor || ( use freetype && use !ftgl ) || !libircclient || use !manpages || use static-libs || use !tools || use !viewer ); then
		einfo
		einfo "You have chosen a use flag setting which is not default and is known to cause problems. If"
		einfo "you experience a failure during the configure phase or during compilation, please use the"
		einfo "default setting as specified in this ebuild. This should be resolved upstream in the future."
		einfo
	fi
}

src_prepare() {

	#This patch corrects the installation locations of icon files and adds additional .desktop files
	#for the configurator, map editor, and model viewer.
	epatch "${FILESDIR}"/${P}-CMakeLists.txt.patch

	#The help2man patch resolves an issue where the compilation may fail when creating the man pages.
	epatch "${FILESDIR}"/${P}-help2man.patch

	if ( use configurator || use editor || use viewer ); then
		# Ensure wxwidgets is the right version
		WX_GTK_VER=2.8
		need-wxwidgets unicode
	fi
}

src_configure() {

# Determine build type
# To Do: The default setting for cmake-utils is CMAKE_BUILD_TYPE=Gentoo. This is the "proper" setting.
# However, when the setting is "Gentoo", MegaGlest is unable to find certain data files even if the
# --data-path=x parameter is passed to megaglest. So we should try to figure out how to fix that.
# By default, "Debug" and "Release" do not respect /etc/make.conf or its CFLAGS settings. To compensate,
# the hard set cmake parameters below compensate to ensure CFLAGS in make.conf are respected.
# See http://devmanual.gentoo.org/eclass-reference/cmake-utils.eclass/index.html for more info.
	if use debug; then
		CMAKE_BUILD_TYPE=Debug
	else
		CMAKE_BUILD_TYPE=Release
	fi

# Determine SSE optimization level
        if use sse3; then
                SSE=3
        elif use sse2; then
                SSE=2
        elif use sse; then
                SSE=1
        elif use !sse; then
                SSE=0
        fi

# Configure cmake

	# Hard set options.
	mycmakeargs=(
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
		"-DMAX_SSE_LEVEL_DESIRED:STRING=${SSE}"
		"-DMEGAGLEST_BIN_INSTALL_PATH=${MY_GAMES_BINDIR}"
		"-DMEGAGLEST_DATA_INSTALL_PATH=${MY_GAMES_DATADIR}/${PN}"
		"-DMEGAGLEST_DESKTOP_INSTALL_PATH=/usr/share/applications"
		"-DMEGAGLEST_ICON_INSTALL_PATH=/usr/share/pixmaps"
		"-DMEGAGLEST_MANPAGE_INSTALL_PATH=/usr/share/man/man6"
		"-DWANT_SVN_STAMP=off"
	)

	# Use cmake-utils to set options according to use flags.
	mycmakeargs+=(
		$(cmake-utils_use_build configurator MEGAGLEST_CONFIGURATOR)
		$(cmake-utils_use curl_dynamic FORCE_CURL_DYNAMIC_LIBS)
		$(cmake-utils_use_build editor MEGAGLEST_MAP_EDITOR)
		$(cmake-utils_use_use freetype FREETYPEGL)
		$(cmake-utils_use_use ftgl FTGL)
		$(cmake-utils_use_want static-libs STATIC_LIBS)
		$(cmake-utils_use static-libs wxWidgets_USE_STATIC)
		$(cmake-utils_use_want streflop STREFLOP)
		$(cmake-utils_use_build tools MEGAGLEST_MODEL_IMPORT_EXPORT_TOOLS)
		$(cmake-utils_use unicode wxWidgets_USE_UNICODE)
		$(cmake-utils_use universal wxWidgets_USE_UNIVERSAL)
		$(cmake-utils_use_build viewer MEGAGLEST_MODEL_VIEWER)
	)

	# Most of the options below require empty values which are not supported by EAPI 3 or otherwise don't fit well with cmake-utils.

	if use debug; then
		mycmakeargs+=(
			"-DBUILD_MEGAGLEST_UPNP_DEBUG:BOOL=ON"
			"-DCMAKE_EXPORT_COMPILE_COMMANDS:BOOL=ON"
			"-DCMAKE_VERBOSE:BOOL=TRUE"
			"-DCMAKE_VERBOSE_MAKEFILE:BOOL=TRUE"
			"-DwxWidgets_USE_DEBUG:BOOL=ON"
			"-LA"
		)

	fi

	if use !manpages; then
		mycmakeargs+=(
			"-DHELP2MAN:FILEPATH="
		)
	fi

	if use !libircclient; then
		mycmakeargs+=(
			"-DIRCCLIENT_INCLUDE_DIR="
			"-DIRCCLIENT_LIBRARY="
		)
	fi
		
	if use !miniupnpc; then
		mycmakeargs+=(
			"-DMINIUPNP_INCLUDE_DIR="
			"-DMINIUPNP_LIBRARY="
		)
	fi

	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
}

src_install() {

	DOCS="AUTHORS.source_code.txt CHANGELOG.txt README.txt"

	cmake-utils_src_install

	prepgamesdirs
}

pkg_postinst() {
	echo
	einfo Note about Configuration:
	einfo DO NOT directly edit glest.ini and glestkeys.ini but rather edit glestuser.ini
	einfo and glestuserkeys.ini and create your user over-ride values in these files.
	einfo On Linux, these files are located in \~/.megaglest/
	einfo
	einfo If you have an older graphics card which only fully supports OpenGL 1.2, and the
	einfo game crashes when you try to play, try starting with \"megaglest --disable-vbo\"
	einfo Some graphics cards may require setting Max Lights to 1.
	echo
	
	games_pkg_postinst
}
