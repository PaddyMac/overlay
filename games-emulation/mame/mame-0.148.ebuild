# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit games

DESCRIPTION="Multiple Arcade Machine Emulator"
HOMEPAGE="http://mamedev.org/"
SRC_URI="http://mamedev.mameworld.info/releases/mame0148s.zip
	http://mamedev.thiswebhost.com/releases/mame0148s.zip
	http://mame.mirrors.zippykid.com/releases/mame0148s.zip
	http://emumovies.com/aarongiles/releases/mame0148s.zip"

LICENSE="XMAME"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="+X debug gtk_debug +mame mess network +opengl profiling qt_debug tinymame tinymess xinput"
REQUIRED_USE="debug? ( X ^^ ( gtk_debug qt_debug ) )
	      gtk_debug? ( debug !qt_debug )
	      qt_debug? ( debug !gtk_debug )
	      xinput? ( X )"

RDEPEND="dev-libs/expat
	media-libs/flac
	media-libs/fontconfig
	media-libs/libsdl:0[audio,joystick,opengl?,video]
	media-libs/portmidi
	media-libs/sdl-ttf
	sys-libs/zlib
	virtual/jpeg
	debug? ( gtk_debug? ( gnome-base/gconf:2
			 x11-libs/gtk+:2 )
		  qt_debug? ( x11-libs/qt-core:4
			 x11-libs/qt-gui:4 ) )
	opengl? ( virtual/opengl )
	X? ( x11-libs/libX11
	     x11-libs/libXinerama )
	xinput? ( x11-libs/libXext
		  x11-libs/libXi )"
DEPEND="${RDEPEND}
	app-arch/unzip
	virtual/pkgconfig"

S=${WORKDIR}

src_unpack() {
	default
	unpack ./mame.zip
	rm -f mame.zip
}

src_prepare() {
	default

	epatch ${FILESDIR}/${P}-linker.patch
	epatch ${FILESDIR}/${P}-makefile.patch
	epatch ${FILESDIR}/${P}-sdl.mak.patch

	if use xinput; then
		echo
		einfo "You have enabled the xinput option. Please be aware that you may experience"
		einfo "issues with mouse capture - especially when using MESS."
		echo
	fi
}

src_compile() {
	einfo "Grab a cup of coffee or a beer. This will take a while."
# Options affecting the root 'makefile' are: TARGET, BUILD_EXPAT, BUILD_FLAC,
# BUILD_JPEGLIB, BUILD_MIDILIB, BUILD_ZLIB, DEBUG, NOWERROR, PROFILER,
# USE_NETWORK, VERBOSE
#
# Options affecting src/osd/sdl/sdl.mak are: NO_OPENGL, NO_X11, NO_USE_XINPUT,
# NO_DEBUGGER, USE_NETWORK, USE_QTDEBUG

	local MY_OPTS=(
		BUILD_EXPAT=0
		BUILD_FLAC=0
		BUILD_JPEGLIB=0
		BUILD_MIDILIB=0
		BUILD_ZLIB=0
		NOWERROR=1
		$(usex X "NO_X11=0" "NO_X11=1")
		$(usex debug "DEBUG=1" "DEBUG=0")
		$(usex debug "NO_DEBUGGER=0" "NO_DEBUGGER=1")
		$(usex opengl "NO_OPENGL=0" "NO_OPENGL=1")
		$(usex profiling "PROFILER=1" "PROFILER=0")
		$(usex qt_debug "USE_QTDEBUG=1" "USE_QTDEBUG=0")
		$(usex xinput "NO_USE_XINPUT=0" "NO_USE_XINPUT=1")
	)

	use network && MY_OPTS="${MY_OPTS} USE_NETWORK=1"

	# Compile the binaries
	if use mame; then
		if use tinymame; then
			emake all TARGET=mame SUBTARGET=tiny ${MY_OPTS[@]}
		else
			emake all TARGET=mame ${MY_OPTS[@]}
		fi
	fi
	if use mess; then
		if use tinymess; then
			emake all TARGET=mess SUBTARGET=tiny ${MY_OPTS[@]}
		else
			emake all TARGET=mess ${MY_OPTS[@]}
		fi
	fi

	# Generate default config files
	if use mame; then
		if use tinymame; then
			exec mametiny -cc
		else
			exec mame -cc
		fi
	fi

	if use mess; then
		if use tinymess; then
			exec messtiny -cc
		else
			exec mess -cc
		fi
	fi
}

src_install() {
	use mame && use !tinymame && dogamesbin mame
	use mame && use tinymame && dogamesbin mametiny
	use mess && use !tinymame && dogamesbin mess
	use mess && use tinymess && dogamesbin messtiny

	dobin chdman jedutil ldresample ldverify regrep romcmp split src2html srcclean testkeys unidasm
	use mess && use !tiny && dobin castool floptool imgtool

	insinto ${GAMES_DATADIR}/${PN}
	doins artwork/ hash/ hlsl/ keymaps/
	use mame && doins mame.ini
	use mess && doins mess.ini

	dodoc docs/*
	doman src/osd/sdl/man/*

	doicon ${FILESDIR}/${PN}.png
	use mame && use !tinymame && make_desktop_entry mame "MAME" ${PN}
	use mame && use tinymame && make_desktop_entry mametiny "MAME" ${PN}
	use mess && use !tinymess && make_desktop_entry mess "MESS" ${PN}
	use mess && use tinymess && make_desktop_entry messtiny "MESS" ${PN}

	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst

	if use xinput; then
		echo
		elog "You have enabled the xinput option. Please be aware that you may experience"
		elog "issues with mouse capture - especially when using MESS."
		elog "However, if you are interested in using a Wiimote as a lightgun controller,"
		elog "see http://spritesmods.com/?art=wiimote-mamegun"
		echo
	fi
}
