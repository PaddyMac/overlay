# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils games

DESCRIPTION="an Atari Jaguar emulator"
HOMEPAGE="http://www.icculus.org/virtualjaguar/"
SRC_URI="https://icculus.org/virtualjaguar/tarballs/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

DEPEND="dev-libs/libcdio
	media-libs/libsdl[audio,joystick,opengl,video]
	sys-libs/zlib
	virtual/opengl
	x11-libs/qt-core
	x11-libs/qt-gui
	x11-libs/qt-opengl"

S=${WORKDIR}/${PN}

src_prepare() {
	default
	sed -e "s:@DATADIR@:${GAMES_DATADIR}/${PN}:" "${FILESDIR}/vj.in" > "${T}/vj" || die
}

src_install() {
	dogamesbin ${PN} ${T}/vj

	insinto ${GAMES_DATADIR}/${PN}
	doins -r software

	newicon res/vj-icon.png virtualjaguar.png
	make_desktop_entry vj "Virtual Jaguar" ${PN}

	dodoc docs/{README,TODO,WHATSNEW}
	dohtml res/help.html
	doman docs/virtualjaguar.1

	prepgamesdirs
}

pkg_postinst() {
        games_pkg_postinst

        echo
        elog "For convenience, use the provided script 'vj' to create the necessary user"           
        elog "directories and run Virtual Jaguar."
        elog "You may place Jaguar ROMs in ~/.vj/software"             
        elog
        elog "If you have previously run a version of Virtual Jaguar, please note that"
        elog "the location of the ROMs has changed."
        echo
}
