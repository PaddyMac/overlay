# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
inherit eutils cmake-utils wxwidgets games

DESCRIPTION="Cross-platform 3D realtime strategy game"
HOMEPAGE="http://www.megaglest.org/"

SRC_URI="mirror://sourceforge/${PN}/${PN}-source-${PV}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+configurator curl_dynamic +editor freetype +ftgl debug +libircclient +miniupnpc sse sse2 sse3 static-libs +tools +unicode universal +viewer"

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
	>=media-libs/libsdl-1.2.5[joystick,video]
	media-libs/libogg
	>=media-libs/libpng-1.4
	media-libs/libvorbis
	media-libs/openal
	net-libs/gnutls
	libircclient? ( !static-libs? ( >=net-libs/libircclient-1.6 ) )
	>=net-misc/curl-7.21.0
	miniupnpc? ( !static-libs? ( net-libs/miniupnpc ) )
	sys-apps/help2man
	sys-libs/zlib
	virtual/jpeg
	virtual/opengl
	virtual/glu
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/wxGTK:2.8[X]"
RDEPEND="${DEPEND}
	=games-strategy/megaglest-data-${PV}"
#REQUIRED_USE="^^ ( sse sse2 sse3 )"

S=${WORKDIR}/${PN}-${PV}

# Determine build type
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

pkg_setup() {

	games_pkg_setup

	if use freetype && use ftgl; then
		einfo
		einfo "You have enabled Freetype and FTGL for on-screen fonts."
		einfo "Megaglest will default to using FTGL."
		einfo
	fi

	if use libircclient || use miniupnpc; then
		einfo
		einfo "If you experience compilation failures with either the libircclient or miniupnpc"
		einfo "USE flags enabled. Try disabling these USE flags in order to use the embedded"
		einfo "versions of these libraries."
		einfo
	fi
}

src_prepare() {

	# Ensure wxwidgets is the right version
	WX_GTK_VER=2.8
	need-wxwidgets unicode
}

src_configure() {
	# Configure cmake
	mycmakeargs="
		-DWANT_SVN_STAMP=off
		-DCMAKE_INSTALL_PREFIX=/
		-DMEGAGLEST_BIN_INSTALL_PATH=${GAMES_BINDIR}/
		-DMEGAGLEST_DATA_INSTALL_PATH=${GAMES_DATADIR}/${PN}/
		-DMEGAGLEST_DESKTOP_INSTALL_PATH=/usr/share/applications/
		-DMEGAGLEST_ICON_INSTALL_PATH=/usr/share/pixmaps/
		-DMEGAGLEST_MANPAGE_INSTALL_PATH=/usr/share/man/man6/
		-DMAX_SSE_LEVEL_DESIRED:STRING=${SSE}"

		if use debug; then
			mycmakeargs="${mycmakeargs} -DBUILD_MEGAGLEST_UPNP_DEBUG:BOOL=ON -DwxWidgets_USE_DEBUG:BOOL=ON -LA"
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

		if use static-libs; then
			mycmakeargs="${mycmakeargs} -DWANT_STATIC_LIBS=ON wxWidgets_USE_STATIC=ON"
		elif use !static-libs; then
			mycmakeargs="${mycmakeargs} -DWANT_STATIC_LIBS=OFF wxWidgets_USE_STATIC=OFF"
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
	doins editor.ico || die "doisn editor.ico failed"
	doins g3dviewer.ico || die "doins g3dviewer.ico failed"
	doins glest.ico || die "doins glest.ico failed"
	doins megaglest.ico || die "doins megaglest.ico failed"

	# Install standard documentation
	dodoc AUTHORS.source_code.txt CHANGELOG.txt COPYRIGHT.source_code.txt README.txt gnu_gpl_3.0.txt || die "dodoc failed"
	
	# Install manpage
	doman mk/linux/megaglest.6 || die "doman failed"
	doman mk/linux/megaglest_editor.6 || die "doman failed"
	doman mk/linux/megaglest_g3dviewer.6 || die "doman failed"

	# Install binaries
	dogamesbin mk/linux/megaglest || die "dogamesbin megaglest failed"
	dogamesbin mk/linux/megaglest_editor|| die "dogamesbin megaglest_editor failed"
	dogamesbin mk/linux/megaglest_g3dviewer || die "dogamesbin megaglest_g3dviewer failed"
	dogamesbin mk/linux/megaglest_configurator || die "dogamesbin megaglest_configurator failed"

	# Install icon
	doicon megaglest.png || die "doicon megaglest.png failed"

	# Create desktop menu entries
	make_desktop_entry megaglest MegaGlest ${PN} "Game;StrategyGame"
	make_desktop_entry megaglest_editor "MegaGlest Editor" ${PN} "Game;StrategyGame"
	make_desktop_entry megaglest_g3dviewer "MegaGlest G3Dviewer" ${PN} "Game;StrategyGame"
	make_desktop_entry megaglest_configurator "MegaGlest Configurator" ${PN} "Game;StrategyGame"

	prepgamesdirs
}

pkg_postinst() {
	echo
	einfo Note about Configuration:
	einfo DO NOT directly edit glest.ini and glestkeys.ini but rather edit glestuser.ini
	einfo and glestuserkeys.ini and create your user over-ride values in these files.
	einfo On Linux, these files are located in ~/.megaglest/
	echo
	
	games_pkg_postinst
}