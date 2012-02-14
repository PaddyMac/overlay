# Copyright 1999-2011 Gentoo Foundation
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
IUSE="+configurator curl_dynamic +editor +freetype +ftgl debug +libircclient +manpages +miniupnpc sse sse2 sse3 static-libs +streflop +tools +unicode universal +viewer"

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
	miniupnpc? ( !static-libs? ( net-libs/miniupnpc ) )
	manpages? ( sys-apps/help2man )
	sys-libs/zlib
	virtual/jpeg
	virtual/opengl
	virtual/glu
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/wxGTK:2.8[X]"
RDEPEND="${DEPEND}
	=games-strategy/megaglest-data-${PV}"

S=${WORKDIR}/${PN}-${PV}

# Determine build type
# If you want a normal release, then you want "Gentoo" so it will respect your /etc/make.conf.
# "Release" and "Debug" will *not* respect /etc/make.conf, so any desired settings have to be set in src_configure() and passed to cmake.
# See http://devmanual.gentoo.org/eclass-reference/cmake-utils.eclass/index.html for more info.
	if use debug; then
		CMAKE_BUILD_TYPE=Debug
	else
		CMAKE_BUILD_TYPE=Gentoo
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

pkg_setup() {
	games_pkg_setup

	if use libircclient || use miniupnpc; then
		einfo
		einfo "If you experience compilation failures with either the libircclient or miniupnpc"
		einfo "USE flags enabled. Try disabling these USE flags in order to use the embedded"
		einfo "versions of these libraries."
		einfo
	fi
}

src_prepare() {

	#The help2man patch resolves an issue where the compilation may fail when creating the man pages.
	epatch "${FILESDIR}"/${P}-help2man.patch

	# Ensure wxwidgets is the right version
	WX_GTK_VER=2.8
	need-wxwidgets unicode
}

src_configure() {
	# Configure cmake
#Please be aware that MegaGlest seems to be very picky about path names.
#Avoid trailing backslashes as they can cause runtime errors sesulting in binaries being unable to find their config or data files.

	mycmakeargs="
		-DCMAKE_C_FLAGS:STRING=${CFLAGS}
		-DCMAKE_C_FLAGS_DEBUG:STRING=
		-DCMAKE_CXX_FLAGS:STRING=${CFLAGS}
		-DCMAKE_CXX_FLAGS_DEBUG:STRING=
		-DCMAKE_EXE_LINKER_FLAGS_DEBUG:STRING=${LDFLAGS}
		-DCMAKE_MODULE_LINKER_FLAGS_DEBUG:STRING=${LDFLAGS}
		-DCMAKE_SHARED_LINKER_FLAGS_DEBUG:STRING=${LDFLAGS}
		-DMAX_SSE_LEVEL_DESIRED:STRING=${SSE}
		-DMEGAGLEST_BIN_INSTALL_PATH=${MY_GAMES_BINDIR}
		-DMEGAGLEST_DATA_INSTALL_PATH=${MY_GAMES_DATADIR}/${PN}
		-DMEGAGLEST_DESKTOP_INSTALL_PATH=/usr/share/applications
		-DMEGAGLEST_ICON_INSTALL_PATH=/usr/share/pixmaps
		-DMEGAGLEST_MANPAGE_INSTALL_PATH=/usr/share/man/man6
		-DWANT_SVN_STAMP=off"

		if use debug; then
			mycmakeargs="${mycmakeargs} -DBUILD_MEGAGLEST_UPNP_DEBUG:BOOL=ON -DCMAKE_EXPORT_COMPILE_COMMANDS:BOOL=ON \
			-DCMAKE_VERBOSE:BOOL=TRUE -DCMAKE_VERBOSE_MAKEFILE:BOOL=TRUE -DwxWidgets_USE_DEBUG:BOOL=ON -LA"
		fi

		if use !configurator; then
			mycmakeargs="${mycmakeargs} -DBUILD_MEGAGLEST_CONFIGURATOR:BOOL=OFF"
		fi

		if use curl_dynamic; then
			mycmakeargs="${mycmakeargs} -DFORCE_CURL_DYNAMIC_LIBS:BOOL=ON"
		fi

		if use !editor; then
			mycmakeargs="${mycmakeargs} -DBUILD_MEGAGLEST_MAP_EDITOR:BOOL=OFF"
		fi

		if use freetype; then
			mycmakeargs="${mycmakeargs} -DUSE_FREETYPEGL:BOOL=ON"
		elif use !freetype; then
			mycmakeargs="${mycmakeargs} -DUSE_FREETYPEGL:BOOL=OFF"
		fi

		if use ftgl; then
			mycmakeargs="${mycmakeargs} -DUSE_FTGL:BOOL=ON"
		elif use !ftgl; then
			mycmakeargs="${mycmakeargs} -DUSE_FTGL:BOOL=OFF"
		fi

		if use !manpages; then
			mycmakeargs="${mycmakeargs} -DHELP2MAN:FILEPATH="
		fi

		if use static-libs; then
			mycmakeargs="${mycmakeargs} -DWANT_STATIC_LIBS=ON wxWidgets_USE_STATIC=ON"
		elif use !static-libs; then
			mycmakeargs="${mycmakeargs} -DWANT_STATIC_LIBS=OFF wxWidgets_USE_STATIC=OFF"
		fi

		if use streflop; then
			mycmakeargs="${mycmakeargs} -DWANT_STREFLOP:BOOL=ON"
		elif use !streflop; then
			mycmakeargs="${mycmakeargs} -DWANT_STREFLOP:BOOL=OFF"
		fi

		if use !tools; then
			mycmakeargs="${mycmakeargs} -DBUILD_MEGAGLEST_MODEL_IMPORT_EXPORT_TOOLS:BOOL=OFF"
		fi

		if use unicode; then
			mycmakeargs="${mycmakeargs} wxWidgets_USE_UNICODE:BOOL=ON"
		elif use !unicode; then
			mycmakeargs="${mycmakeargs} wxWidgets_USE_UNICODE:BOOL=OFF"
		fi

		if use universal; then
			mycmakeargs="${mycmakeargs} wxWidgets_USE_UNIVERSAL:BOOL=ON"
		elif use !universal; then
			mycmakeargs="${mycmakeargs} wxWidgets_USE_UNIVERSAL:BOOL=OFF"
		fi

		if use !viewer; then
			mycmakeargs="${mycmakeargs} -DBUILD_MEGAGLEST_MODEL_VIEWER:BOOL=OFF"
		fi
		
		if use !libircclient; then
			mycmakeargs="${mycmakeargs} -DIRCCLIENT_INCLUDE_DIR= -DIRCCLIENT_LIBRARY="
		fi
		
		if use !miniupnpc; then
			mycmakeargs="${mycmakeargs} -DMINIUPNP_INCLUDE_DIR= -DMINIUPNP_LIBRARY="
		fi

	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
}

src_install() {

	# Initialize our installation directory
	insinto "${GAMES_DATADIR}"/${PN}
	
	# Install config files
	doins glest.ini || die "doins glest.ini failed"
	doins glestkeys.ini || die "doins glestkeys.ini failed"
	doins servers.ini || die "doins servers.ini failed"
	
	# Install .ico files

	if use editor; then
		doins editor.ico || die "doisn editor.ico failed"
	fi

	if use viewer; then
		doins g3dviewer.ico || die "doins g3dviewer.ico failed"
	fi

	if use configurator; then
		doins glest.ico || die "doins glest.ico failed"
	fi

	doins megaglest.ico || die "doins megaglest.ico failed"

	# Install standard documentation
	dodoc AUTHORS.source_code.txt CHANGELOG.txt COPYRIGHT.source_code.txt README.txt gnu_gpl_3.0.txt || die "dodoc failed"
	
	# Install manpages

	if use manpages; then
		doman mk/linux/megaglest.6 || die "doman failed"

		if use editor; then
			doman mk/linux/megaglest_editor.6 || die "doman failed"
		fi

		if use viewer; then
			doman mk/linux/megaglest_g3dviewer.6 || die "doman failed"
		fi
	fi

	# Install binaries
	dogamesbin mk/linux/megaglest || die "dogamesbin megaglest failed"

	if use editor; then
		dogamesbin mk/linux/megaglest_editor|| die "dogamesbin megaglest_editor failed"
	fi

	if use viewer; then
		dogamesbin mk/linux/megaglest_g3dviewer || die "dogamesbin megaglest_g3dviewer failed"
	fi

	if use configurator; then
		dogamesbin mk/linux/megaglest_configurator || die "dogamesbin megaglest_configurator failed"
	fi

	# Install icon
	doicon megaglest.png || die "doicon megaglest.png failed"

	# Create desktop menu entries
	make_desktop_entry megaglest MegaGlest ${PN} "Game;StrategyGame"

	if use editor; then
		make_desktop_entry megaglest_editor "MegaGlest Editor" ${PN} "Game;StrategyGame"
	fi

	if use viewer; then
		make_desktop_entry megaglest_g3dviewer "MegaGlest G3Dviewer" ${PN} "Game;StrategyGame"
	fi

	if use configurator; then
		make_desktop_entry megaglest_configurator "MegaGlest Configurator" ${PN} "Game;StrategyGame"
	fi

	prepgamesdirs
}

pkg_postinst() {
	echo
	einfo Note about Configuration:
	einfo DO NOT directly edit glest.ini and glestkeys.ini but rather edit glestuser.ini
	einfo and glestuserkeys.ini and create your user over-ride values in these files.
	einfo On Linux, these files are located in ~/.megaglest/
	einfo
	einfo If you have an older graphics card which only fully supports OpenGL 1.2, and the
	einfo game crashes when you try to play, try starting with "megaglest --disable-vbo"
	einfo and lower some of the graphics settings such as color depth 16 and/or setting the
	einfo number of lights to 1 before starting play.
	echo
	
	games_pkg_postinst
}
