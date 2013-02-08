# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit versionator eutils games

MY_PV=$(replace_version_separator 2 - )

DESCRIPTION="Freedoom - Open Source Doom resources"
HOMEPAGE="http://www.nongnu.org/freedoom/"
SRC_URI="mirror://nongnu/freedoom/freedoom-iwad/freedoom-iwad-${MY_PV}.zip
	mirror://nongnu/freedoom/freedm/freedm-${MY_PV}.zip
	mirror://nongnu/freedoom/freedoom-iwad/ultimate/freedoom-ultimate-${MY_PV}.zip"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="+symlink"

DEPEND="app-arch/unzip"

S=${WORKDIR}

src_install() {
	insinto "${GAMES_DATADIR}"/doom-data/${PN}
	doins */*.wad || die "doins wad"
	dodoc freedoom-iwad-${MY_PV}/{BUILD-SYSTEM,ChangeLog,CREDITS,NEWS,README}
	dohtml freedoom-iwad-${MY_PV}/{BUILD-SYSTEM,README}.html
	if use symlink; then
		dosym "${GAMES_DATADIR}"/doom-data/${PN}/doom.wad "${GAMES_DATADIR}"/doom-data/doom.wad
		dosym "${GAMES_DATADIR}"/doom-data/${PN}/doom2.wad "${GAMES_DATADIR}"/doom-data/doom2.wad
		dosym "${GAMES_DATADIR}"/doom-data/${PN}/freedm.wad "${GAMES_DATADIR}"/doom-data/freedm.wad
	fi
	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst
	elog "A Boom-compatible Doom engine is required to use Freedoom.
	elog "Other Doom engines will have limited or no functionality with Freedoom.
	elog
	elog "These wads are provided by Freedoom:"
	elog "doom.wad: Provides all the resources found in The Ultimate Doom."
	elog "          Allows the full catalog of PWADs for Doom 1 to be used."
	elog "doom2.wad: Complete independent Doom II game."
	elog "freedm.wad: High-quality deathmatch levels."
}
