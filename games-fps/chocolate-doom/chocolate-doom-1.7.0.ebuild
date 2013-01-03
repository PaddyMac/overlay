# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit games autotools

DESCRIPTION="Doom port designed to act identically to the original game"
HOMEPAGE="http://www.chocolate-doom.org/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="python timidity"

DEPEND=">=media-libs/libsdl-1.1.3
	media-libs/sdl-mixer
	media-libs/sdl-net
	python? ( dev-lang/python )
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

	# Ensure chocolate-setup binary is installed into the correct directory.
	sed -i \
		-e "s:^gamesdir =.*:gamesdir = ${GAMES_BINDIR}:" \
		setup/Makefile.am || die "sed Makefile.am failed"

	# Ensure chocolate-doom and chocolate-server binaries are installed into the correct directory.
	sed -i \
		-e "s:^gamesdir =.*:gamesdir = ${GAMES_BINDIR}:" \
		src/Makefile.am || die "sed Makefile.am failed"

	# Ensure .desktop files are installed into the correct directory.
	sed -i \
		-e "s:^appdir =.*:appdir = /usr/share/applications:" \
		src/Makefile.am || die "sed Makefile.am failed"

	sed -i \
		-e "s:^appdir =.*:appdir = /usr/share/applications:" \
		setup/Makefile.am || die "sed Makefile.am failed"

	# Ensure docs are installed into correct directory.
	sed -i \
		-e "s:^docdir=.*:docdir=/usr/share/doc:" \
		Makefile.am || die "sed Makefile.am failed"

	sed -i \
		-e "s:^docdir=.*:docdir=/usr/share/doc:" \
		man/Makefile.am || die "sed Makefile.am failed"

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

	egamesconf \
		--disable-sdltest \
		--disable-dependency-tracking \
		--docdir=/usr/share/doc \
		|| die "egamesconf failed"
}

pkg_postinst() {
	games_pkg_postinst

	einfo
	einfo "To play the original Doom levels, place doom.wad and/or doom2.wad"
	einfo "into "${GAMES_DATADIR}"/doom-data, then run: ${PN}"
	einfo
	einfo "To configure game options run:  chocolate-setup"
	einfo
}
