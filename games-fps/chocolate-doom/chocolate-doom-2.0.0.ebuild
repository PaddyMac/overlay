# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit autotools games

DESCRIPTION="Doom port designed to act identically to the original game"
HOMEPAGE="http://www.chocolate-doom.org/"
SRC_URI="http://www.chocolate-doom.org/downloads/${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="python timidity"

DEPEND="media-libs/libsdl
	media-libs/sdl-mixer
	media-libs/sdl-net
	python? ( dev-python/imaging )
	timidity? ( media-libs/sdl-mixer[midi,timidity] )"
RDEPEND="${DEPEND}"

src_prepare() {

	# Change default search path for IWAD
	sed -i \
		-e "s:/usr/share/games/doom:${GAMES_DATADIR}/doom-data:" \
		src/d_iwad.c || die "sed main.c failed"

	# This *should* allow Chocolate Doom to look for WAD files in a user's ~/.doom-data directory also.
	sed -i \
		-e "s:/usr/local/share/games/doom:~/.doom-data:" \
		src/d_iwad.c || die "sed main.c failed"

	# Ensure the binaries are installed into the correct directory.
	sed -i \
		-e "s:^execgamesdir =.*:execgamesdir = ${GAMES_BINDIR}:" \
		src/Makefile.am || die "sed Makefile.am failed"

	# Ensure .desktop files are installed into the correct directory.
	sed -i \
		-e "s:^appdir =.*:appdir = /usr/share/applications:" \
		src/Makefile.am || die "sed Makefile.am failed"

	sed -i \
                -e "s:^appdir =.*:appdir = /usr/share/applications:" \
                src/setup/Makefile.am || die "sed Makefile.am failed"

	# Ensure docs are installed into correct directory.
	sed -i \
		-e "s:^doomdocsdir =.*:doomdocsdir = /usr/share/doc/${PF}/doom:" \
		Makefile.am || die "sed Makefile.am failed"

        sed -i \
                -e "s:^hereticdocsdir =.*:hereticdocsdir = /usr/share/doc/${PF}/heretic:" \
                Makefile.am || die "sed Makefile.am failed"

        sed -i \
                -e "s:^hexendocsdir =.*:hexendocsdir = /usr/share/doc/${PF}/hexen:" \
                Makefile.am || die "sed Makefile.am failed"

        sed -i \
                -e "s:^strifedocsdir =.*:strifedocsdir = /usr/share/doc/${PF}/strife:" \
                Makefile.am || die "sed Makefile.am failed"

	# Ensure icons are installed into the correct directory.
	sed -i \
		-e "s:^iconsdir =.*:iconsdir = /usr/share/pixmaps:" \
		data/Makefile.am || die "sed Makefile.am failed"

	# Ensure screensaver is installed into the correct directory.
	sed -i \
		-e "s:^screensaverdir =.*:screensaverdir = /usr/share/applications/screensavers:" \
		src/Makefile.am || die "sed Makefile.am failed"

	eautoreconf
}

src_configure() {

	if use python; then
		export HAVE_PYTHON="true"
	else
		export HAVE_PYTHON="false"
	fi

	egamesconf
}

src_install() {
	DOCS=(AUTHORS HACKING)

	default

	make_desktop_entry "chocolate-doom" "Chocolate Doom" "chocolate-doom" "Game;Shooter;"
	#The default install installs a .desktop file for Chocolate Doom Setup.
	make_desktop_entry "chocolate-heretic" "Chocolate Heretic" "chocolate-doom" "Game;Shooter;"
	make_desktop_entry "chocolate-heretic-setup" "Chocolate Heretic Setup" "chocolate-setup" "Game;Shooter;"
	make_desktop_entry "chocolate-hexen" "Chocolate Hexen" "chocolate-doom" "Game;Shooter;"
	make_desktop_entry "chocolate-hexen-setup" "Chocolate Hexen Setup" "chocolate-setup" "Game;Shooter;"
	make_desktop_entry "chocolate-strife" "Chocolate Strife" "chocolate-doom" "Game;Shooter;"
	make_desktop_entry "chocolate-strife-setup" "Chocolate Strife Setup" "chocolate-setup" "Game;Shooter;"

	keepdir "${GAMES_STATEDIR}/run/chocolate-doom"

	doinitd ${FILESDIR}/init.d/chocolate-server
	doconfd ${FILESDIR}/conf.d/chocolate-server

	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst

	einfo
	einfo "To play the original Doom levels, place doom.wad and/or doom2.wad into          "
	einfo " "${GAMES_DATADIR}"/doom-data. You may also emerge games-fps/doom-data          "
	einfo "for the shareware version or games-fps/freedoom for a free Doom2 data           "
	einfo "replacement. Please see http://www.chocolate-doom.org/wiki/index.php/Freedoom   "
	einfo "if you wish to use Freedoom.                                                    "
	einfo
}
