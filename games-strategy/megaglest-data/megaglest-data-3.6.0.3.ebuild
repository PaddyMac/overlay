# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
inherit eutils games

MY_PN="megaglest"
DESCRIPTION="Data files for the cross-platform 3D realtime strategy game MegaGlest"
HOMEPAGE="http://www.megaglest.org/"
SRC_URI="mirror://sourceforge/${PN}/${PN}-${PV}.tar.xz"

LICENSE="CCPL-Attribution-ShareAlike-3.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

DEPEND="app-arch/xz-utils"
RDEPEND=""
PDEPEND=">=games-strategy/megaglest-${PV}"

S=${WORKDIR}/${MY_PN}-${PV}

#src_prepare() {
#	# The 3.5.2.4 data archive includes the Windows version of configuration.xml. Patch it to match the Linux version.
#	epatch "${FILESDIR}"/megaglest-linux-configuration.xml-${PV}.patch
#}

src_install() {
	# Initialize installation directory
	insinto "${GAMES_DATADIR}"/${MY_PN}
	
	# insert configuration file for megaglest_configurator
	doins configuration.xml
	
	# insert megaglest game data
        doins -r data maps scenarios techs tilesets tutorials || die "doins data failed"
        
        # insert standard documentation
        dodoc docs/AUTHORS.data.txt docs/COPYRIGHT.data.txt docs/README.data-license.txt docs/cc-by-sa-3.0-unported.txt || die "dodoc failed"
	
	# If DOC USE flag is enabled, install optional documentation.
	if use doc; then
	dohtml -r docs/glest_factions/ || die "dohtml failed"
	fi
	
	# Set proper permissions
	prepgamesdirs
}
