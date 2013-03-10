# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python{2_6,2_7} )

inherit python-single-r1 confutils eutils qt4-r2 games

DESCRIPTION="A modern gaming engine for Doom, Heretic, and Hexen"
HOMEPAGE="http://www.dengine.net/"
SRC_URI="mirror://sourceforge/deng/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="debug demo +doom fluidsynth fmod freedoom heretic hexen openal resources +sdl snowberry +tools"

DEPEND="dev-qt/qtcore:4
	dev-qt/qtgui:4
	dev-qt/qtopengl:4
	media-libs/libpng
	media-libs/libsdl[joystick,opengl]
	media-libs/sdl-net
	net-misc/curl
	sys-libs/ncurses
	sys-libs/zlib
	x11-libs/libXrandr
	x11-libs/libXxf86vm
	virtual/glu
	virtual/opengl
	virtual/pkgconfig
	fluidsynth? ( media-sound/fluidsynth )
	fmod? ( >=media-libs/fmod-4.44.03 )
	openal? ( media-libs/freealut
		media-libs/openal )
	sdl? ( media-libs/libsdl[audio]
		media-libs/sdl-mixer[midi,mod,mp3,vorbis] )"
RDEPEND="${DEPEND}
	snowberry? ( dev-python/wxpython )"
PDEPEND="
	demo? ( games-fps/doom-data )
	freedoom? ( games-fps/freedoom )
	resources? ( games-fps/doomsday-resources )"

S=${S}/${PN}

REQUIRED_USE="demo? ( doom ) freedoom? ( doom ) resources? ( doom )"

# Notes about patches:  1) 1.9.10-driver_openal.cpp and 1.9.10-threadsafe address issues already fixed upstream, so
#			   these patches should be unnecessary in future ebuilds.

PATCHES=( "${FILESDIR}"/${PN}-1.9.10-driver_openal.cpp.patch
	  "${FILESDIR}"/${PN}-1.9.10-threadsafe.patch
	  "${FILESDIR}"/${PN}-1.9.10-python_build.patch )

pkg_setup(){
	games_pkg_setup
}

src_prepare() {

	# Various informative messages.
	if ( use !fluidsynth && use !fmod && use !openal && use !sdl ); then
		ewarn
		ewarn "You have not enabled any sound drivers for Doomsday. Doomsday will"
		ewarn "compile and run without any music or sound effects. If you wish to"
		ewarn "have audio, enable the fluidsynth, fmod, openal, and/or, sdl USE flags."
		ewarn
	fi

	if ( use openal && use !fluidsynth && use !fmod && use !sdl ); then
		ewarn
		ewarn "You have enabled OpenAL support for sound effects, but you must still"
		ewarn "enable fmod, fluidsynth, or sdl USE flags to enable in-game music."
		ewarn
	fi

	if ( use fluidsynth && use !fmod && use !openal && use !sdl ); then
		ewarn
		ewarn "You have enabled Fluidsynth for MIDI/MUS background music. However, you"
		ewarn "must still enable fmod, openal, or sdl USE flags to enable sound effects."
		ewarn
	fi

	# Fix installation paths.
	sed -i -e "/^DENG_BIN_DIR =/s:\$\$PREFIX/bin:${GAMES_BINDIR}:" config_unix.pri
	sed -i -e "/^DENG_BASE_DIR =/s:\$\$PREFIX/share:${GAMES_DATADIR}:" config_unix.pri

	# Set the python interpreter to use in the launch-doomsday script which runs Snowberry
	echo "SCRIPT_PYTHON = /usr/bin/python2" >> config_user.pri

	if use debug; then
		echo "CONFIG += debug" >> config_user.pri
	else
		echo "CONFIG += release" >> config_user.pri
	fi

	if use fluidsynth; then
		echo "CONFIG += deng_fluidsynth" >> config_user.pri
	fi

	if use fmod; then
		echo "CONFIG += deng_fmod" >> config_user.pri
		echo "FMOD_DIR = /opt/fmodex" >> config_user.pri
	fi

	if use openal; then
		echo "CONFIG += deng_openal" >> config_user.pri
	else
		echo "CONFIG += deng_noopenal" >> config_user.pri
	fi

	if use !sdl; then
		echo "CONFIG += deng_nosdlmixer" >> config_user.pri
	fi

	if use snowberry; then
		echo "CONFIG += deng_snowberry" >> config_user.pri
	else
		echo "CONFIG += deng_nosnowberry" >> config_user.pri
	fi

	if use !tools; then
		echo "CONFIG += deng_notools" >> config_user.pri
	fi

	qt4-r2_src_prepare
}

#Usage: doom_make_wrapper <name> <game> <icon> <desktop entry title> [args]
doom_make_wrapper() {
	local name=$1 game=$2 icon=$3 de_title=$4
	shift 4
	games_make_wrapper $name \
		"doomsday -game ${game} $@"
	make_desktop_entry $name "${de_title}" ${icon}
}

src_configure() {
	qt4-r2_src_configure
}

src_install() {
	qt4-r2_src_install

	mv "${D}/${GAMES_DATADIR}"/{${PN}/data/jdoom,doom-data} || die
	dosym "${GAMES_DATADIR}"/doom-data "${GAMES_DATADIR}"/${PN}/data/jdoom || die

	if use doom; then
		local res_arg
		if use resources; then
			res_arg="-def \"${GAMES_DATADIR}\"/${PN}/defs/jdoom/jDRP.ded"
		fi

		doicon ../snowberry/graphics/orb-doom.png
		doom_make_wrapper jdoom doom1 orb-doom "Doomsday Engine: Doom 1" "${res_arg}"
		elog "Created jdoom launcher. To play Doom place your doom.wad to"
		elog "\"${GAMES_DATADIR}/doom-data\""
		elog

		if use demo; then
			doom_make_wrapper jdoom-demo doom1-share orb-doom "Doomsday Engine: Doom 1 Demo" \
				"-iwad \"${GAMES_DATADIR}\"/doom-data/doom1.wad ${res_arg}"
		fi
		if use freedoom; then
			doom_make_wrapper jdoom-freedoom doom1-share orb-doom "Doomsday Engine: FreeDoom" \
				"-iwad \"${GAMES_DATADIR}\"/doom-data/freedoom/doom1.wad"
		fi
	fi
	if use hexen; then
		doicon ../snowberry/graphics/orb-hexen.png
		doom_make_wrapper jhexen hexen orb-hexen "Doomsday Engine: Hexen"

		elog "Created jhexen launcher. To play Hexen place your hexen.wad to"
		elog "\"${GAMES_DATADIR}/${PN}/data/jhexen\""
		elog
	fi
	if use heretic; then
		doicon ../snowberry/graphics/orb-heretic.png
		doom_make_wrapper jheretic heretic orb-heretic "Doomsday Engine: Heretic"

		elog "Created jheretic launcher. To play Heretic place your heretic.wad to"
		elog "\"${GAMES_DATADIR}/${PN}/data/jheretic\""
		elog
	fi

	if use fluidsynth; then
		elog "You have enabled Fluidsynth MIDI music support in Doomsday. You must install"
		elog "a soundfont such as media-sound/fluid-soundfont, and then set the in-game"
		elog "music-soundfont variable, i.e. \"music-soundfont /usr/share/sounds/sf2/FluidR3_GM.sf2\""
		elog "You still must enable fmod, openal, or sdl-mixer for sound effects."
	fi

	if use fmod; then
		elog "You have enabled FMOD support in Doomsday. Under the default setup, you"
		elog "will have sound effects but no music. You must install a soundfont such"
		elog "as media-sound/fluid-soundfont, and then set the in-game music-soundfont"
		elog "variable, i.e. \"music-soundfont /usr/share/sounds/sf2/FluidR3_GM.sf2\""
	fi

	prepgamesdirs
}
