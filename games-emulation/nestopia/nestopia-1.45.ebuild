# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit eutils flag-o-matic games

MY_PV="${PV//./}"
LNX_P="nst${MY_PV}_lnx_release_h"
DESCRIPTION="NEStopia is a portable Nintendo Entertainment System emulator written in C++"
HOMEPAGE="http://0ldsk00l.ca/nestopia/ http://rbelmont.mameworld.info/?page_id=200"
SRC_URI="mirror://sourceforge/nestopiaue/${PV}/nestopia-${PV}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RDEPEND="app-arch/libarchive
	media-libs/alsa-lib
	>=media-libs/libsdl-1.2.12[audio,joystick,video]
	sys-libs/zlib
	x11-libs/gtk+:3
	x11-libs/libX11
	virtual/opengl
	virtual/glu"
DEPEND="${RDEPEND}
	app-arch/unzip"

src_prepare() {
	sed -i -e "s:CC   = @gcc:#CC   = @gcc:" Makefile || die "sed Makefile 1/4 failed"
	sed -i -e "s:CXX  = @g++:#CXX  = @g++:" Makefile || die "sed Makefile 2/4 failed"
	sed -i -e "/^PREFIX = /s:/usr/local:${GAMES_PREFIX}:" Makefile || die "sed Makefile 3/4 failed"
	sed -i -e "/^DATADIR = /s:\$(PREFIX)/share/nestopia:${GAMES_DATADIR}/${PN}:" Makefile || die "sed Makefile 4/4 failed"

	strip-flags
}

src_install() {
	dogamesbin nestopia

	insinto ${GAMES_DATADIR}/${PN}
	doins NstDatabase.xml

	insinto ${GAMES_DATADIR}/${PN}/icons
	doins source/unix/icons/*.{png,svg}

	doicon source/unix/icons/nestopia.svg
	domenu source/unix/icons/nestopia.desktop

	dodoc README.md README.unix changelog.txt
	dohtml readme.html
	dohtml -r doc/

	prepgamesdirs
}
