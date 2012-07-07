# Copyright 2008-2012 Funtoo Technologies
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit eutils games

DESCRIPTION="PrBoom+ is a Doom source port developed from the original PrBoom project by Andrey Budko"
HOMEPAGE="http://prboom-plus.sourceforge.net/ http://sourceforge.net/projects/prboom-plus/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz
	mirror://gentoo/prboom.png"

LICENSE=""
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="dumb fluidsynth mad +opengl +pcre +png portmidi +sdl_image +sdl_mixer +sdl_net vorbis"

DEPEND="dumb? ( media-libs/dumb )
	fluidsynth? ( media-sound/fluidsynth )
	mad? ( media-libs/libmad )
	opengl? ( virtual/opengl
		virtual/glu )
	pcre? ( dev-libs/libpcre )
	png? ( media-libs/libpng )
	portmidi? ( media-libs/portmidi )
	sdl_image? ( media-libs/sdl-image )
	sdl_mixer? ( media-libs/sdl-mixer[midi,timidity] )
	sdl_net? ( media-libs/sdl-net )
	vorbis? ( media-libs/libvorbis )
	media-libs/libsdl[joystick,video]"
RDEPEND="${DEPEND}"

src_prepare() {
	sed -i \
		-e 's:-ffast-math $CFLAGS_OPT::' \
		configure \
		|| die "sed configure failed"
}

src_configure() {
	egamesconf \
		$(use_with dumb) \
		$(use_with fluidsynth) \
		$(use_with mad) \
		$(use_with sdl_mixer mixer) \
		$(use_with sdl_net net) \
		$(use_enable opengl gl) \
		$(use_with pcre) \
		$(use_with png) \
		$(use_with portmidi) \
		$(use_with sdl_image image) \
		$(use_with vorbis vorbisfile) \
		--disable-cpu-opt \
		--with-waddir="${GAMES_DATADIR}/doom-data"
}

src_install() {
	dogamesbin src/prboom-plus src/prboom-plus-game-server
	insinto "${GAMES_DATADIR}/doom-data"
	doins data/prboom-plus.wad
	doman doc/*.{5,6}
	dodoc AUTHORS NEWS README TODO doc/README.* doc/*.txt
	dohtml doc/prboom-plus-history.html
	cp "${DISTDIR}"/prboom.png prboom-plus.png
        doicon prboom-plus.png
        make_desktop_entry "${PN}" "PrBoom+" "prboom-plus" "Game;ActionGame;"
        prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst
	elog "To play the original Doom levels, place doom.wad and/or doom2.wad"
	elog "into ${GAMES_DATADIR}/doom-data"
	elog "Then run ${PN} accordingly."
	elog
	elog "doom1.wad is the shareware demo wad consisting of 1 episode,"
	elog "and doom.wad is the full Doom 1 set of 3 episodes"
	elog "(or 4 in the Ultimate Doom wad)."
	elog
	elog "You can even emerge doom-data and/or freedoom to play for free."
}
