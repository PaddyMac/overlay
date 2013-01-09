# Distributed under the terms of the GNU General Public License v2

EAPI=4

inherit games

DESCRIPTION="An enhanced client for id Software's Quake II with full 64-bit support."
HOMEPAGE="http://www.yamagi.org/quake2/ https://github.com/yquake2/yquake2"
SRC_URI="http://deponie.yamagi.org/quake2/quake2-${PV}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~sparc"
IUSE="cdinstall demo +jpeg +openal +vorbis x11gamma +zlib"
REQUIRED_USE="cdinstall? ( !demo )"

DEPEND="media-libs/libsdl
	virtual/opengl
	jpeg? ( virtual/jpeg )
	openal? ( media-libs/openal )
	vorbis? ( media-libs/libogg
		  media-libs/libvorbis )
	x11gamma? ( virtual/pkgconfig
		    x11-libs/libX11
		    x11-libs/libXxf86vm )
	zlib? ( sys-libs/zlib )"
RDEPEND="${DEPEND}
	cdinstall? ( games-fps/quake2-data )
	demo? ( games-fps/quake2-demodata[symlink] )"

S=${WORKDIR}/quake2-${PV}

src_prepare() {
	local myconf

	if use !jpeg; then
		sed -i -e "/^WITH_RETEXTURING:=/s:yes:no:" Makefile
	fi

	if use !openal; then
		sed -i -e "/^WITH_OPENAL:=/s:yes:no:" Makefile
	fi

	if use !vorbis; then
		sed -i -e "/^WITH_OGG:=/s:yes:no:" Makefile
	fi

	if use x11gamma; then
		sed -i -e "/^WITH_X11GAMMA:=/s:no:yes:" Makefile
	fi

	if use !zlib; then
		sed -i -e "/^WITH_ZIP:=/s:yes:no:" Makefile
	fi

	sed -i -e "/^WITH_SYSTEMWIDE:=/s:no:yes:" Makefile

	sed -i "/WITH_SYSTEMDIR:=/s|$|${GAMES_DATADIR}/quake2|" Makefile
}

src_compile() {
	emake
}

src_install() {
	# Rename and install binaries
	mv release/quake2 release/yamagi-quake2
	dogamesbin release/yamagi-quake2
	mv release/q2ded release/yamagi-quake2-server
	dogamesbin release/yamagi-quake2-server

	# Install wrapper scripts for binaries
	dogamesbin ${FILESDIR}/yq2
	dogamesbin ${FILESDIR}/yq2-server

	# Install shared libraries and config file.
	insinto ${GAMES_DATADIR}/${PN}
	doins release/ref_gl.so
	doins stuff/yq2.cfg
	insinto ${GAMES_DATADIR}/${PN}/baseq2
	doins release/baseq2/game.so

	# Install extra goodies
	insinto ${GAMES_DATADIR}/${PN}/stuff
	doins stuff/cdripper.sh
	doins stuff/quake2-start.sh

	# Install icon and make desktop entries.
	newicon stuff/icon/Quake2.png yamagi-quake2.png
	make_desktop_entry "yq2" "Yamagi Quake II" "${PN}"
	make_desktop_entry "yq2-server" "Yamagi Quake II server" "${PN}"

	# Install documentation
	dodoc CHANGELOG CONTRIBUTE README
	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst
	elog
	elog "For convenience, you may use the wrapper scripts \"yq2\" and \"yq2-server\""
	elog "to run the game or the server, respectively."
	elog
}
