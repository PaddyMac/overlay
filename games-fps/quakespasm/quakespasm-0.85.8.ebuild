# Distributed under the terms of the GNU General Public License v2

EAPI=4

inherit games

DESCRIPTION="QuakeSpasm is a Quake 1 engine based on the SDL port of FitzQuake."
HOMEPAGE="http://quakespasm.sourceforge.net/"
SRC_URI="mirror://sourceforge/quakespasm/Source/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="cdinstall +consolebackground demo +mad +mp3 mpg123 +ogg +sdl-net tremor +vorbis +wav"
REQUIRED_USE="cdinstall? ( !demo )
	      mp3? ( ^^ ( mad mpg123 ) )
	      ogg? ( ^^ ( tremor vorbis ) )"

DEPEND="media-libs/libsdl[opengl]
	virtual/opengl
	x11-libs/libX11
	mp3? (  mad?    ( media-libs/libmad )
		mpg123? ( media-sound/mpg123 ) )
	ogg? (  tremor? ( media-libs/tremor )
		vorbis? ( media-libs/libvorbis ) )
	sdl-net? ( media-libs/sdl-net )"
RDEPEND="${DEPEND}
	cdinstall? ( games-fps/quake1-data )
	demo? ( games-fps/quake1-demodata[symlink] )"

src_prepare() {
	# Apply upstream patches
	epatch Misc/homedir_0.patch
	epatch Misc/quake_retexturing_project.patch

	# Remove -O2 from appended CFLAGS
	sed -i '/CFLAGS += -O2/d' Quake/Makefile

	# Remove automatic stripping of binary and let Portage do that
	sed -i '/\$(call cmd_strip,\$(1));/d' Quake/Makefile
}

src_compile() {
	local myconf=""

	if use consolebackground; then
		myconf="${myconf} USE_QS_CONBACK=1"
	else
		myconf="${myconf} USE_QS_CONBACK=0"
	fi

	if use mad; then
		myconf="${myconf} MP3LIB=mad"
	fi

	if use mp3; then
		myconf="${myconf} USE_CODEC_MP3=1"
	else
		myconf="${myconf} USE_CODEC_MP3=0"
	fi

	if use mpg123; then
		myconf="${myconf} MP3LIB=mpg123"
	fi

	if use ogg; then
		myconf="${myconf} USE_CODEC_VORBIS=1"
	else
		myconf="${myconf} USE_CODEC_VORBIS=0"
	fi

	if use sdl-net; then
		myconf="${myconf} SDLNET=1"
	else
		myconf="${myconf} SDLNET=0"
	fi

	if use tremor; then
		myconf="${myconf} VORBISLIB=tremor"
	fi

	if use vorbis; then
		myconf="${myconf} VORBISLIB=vorbis"
	fi

	if use wav; then
		myconf="${myconf} USE_CODEC_WAVE=1"
	else
		myconf="${myconf} USE_CODEC_WAVE=0"
	fi

	cd Quake
	echo
	echo My configuration is ${myconf}
	echo
	emake ${myconf}
}

src_install() {
	# Install binary
	dogamesbin ${S}/Quake/quakespasm

	# Install wrapper script
	dogamesbin ${FILESDIR}/quakespasm.sh

	# Install icon
	newicon Misc/QuakeSpasm_512.png quakespasm.png

	# Make desktop menu entry
	make_desktop_entry "quakespasm.sh" "QuakeSpasm" "quakespasm" "Game;ActionGame;"

	# Install standard documentation
	dodoc README.music README.sgml README.txt
	dohtml README.html

	# Ensure permissions are set correctly
	prepgamesdirs
}

pkg_postinst() {
	elog
	elog "By default, QuakeSpasm will look in the current directory for"
	elog "a directory named \"id1\" for game data files. You can have"
	elog "QuakeSpasm look in another subdirectory by using the -game"
	elog "parameter. For example:"
	elog
	elog "\"cd ~/quake\""
	elog "\"quakespasm -game directoryname\""
	elog
	elog "where \"directoryname\" is the directory containing the game data."
	elog
	elog
	elog "The simplest solution may be to create a directory in your user's"
	elog "home directory then symlink the location of game files to it."
	elog
	elog "Example using Quake demo: # emerge -v games-fps/quake1-demodata"
	elog "                          $ mkdir ~/quake"
	elog "                          $ cd ~/quake"
	elog "                          $ ln -s /usr/share/games/quake1/demo/ id1"
	elog "                          $ quakespasm"
	elog
}
