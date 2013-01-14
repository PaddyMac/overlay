# Distributed under the terms of the GNU General Public License v2

EAPI=4

inherit games waf-utils subversion

DESCRIPTION="Quake 2 based engine with glsl per pixel lighting effects and more"
HOMEPAGE="http://quake2xp.sourceforge.net/"
SRC_URI="mirror://sourceforge/quake2xp/media/baseq2/q2xpMusic.pkx
	 mirror://sourceforge/quake2xp/media/baseq2/q2xpMdl1.pkx
	 mirror://sourceforge/quake2xp/media/baseq2/q2xpTex0.pkx
	 mirror://sourceforge/quake2xp/media/baseq2/q2xpMdl.pkx
	 mirror://sourceforge/quake2xp/media/baseq2/q2xpCache.pkx
	 mirror://sourceforge/quake2xp/media/baseq2/q2xp0.pkx
	 rogue? ( mirror://sourceforge/quake2xp/media/rogue/q2xpR.pkx )
	 xatrix? ( mirror://sourceforge/quake2xp/media/xatrix/q2xpX.pkx
		   mirror://sourceforge/quake2xp/media/xatrix/q2xpXcache.pkx )"
ESVN_REPO_URI="svn://svn.code.sf.net/p/quake2xp/code/trunk"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="rogue xatrix"

DEPEND="app-text/dos2unix
	media-libs/devil
	media-libs/libsdl
	media-libs/libvorbis
	>=media-libs/openal-1.14
	virtual/opengl"

RDEPEND="games-fps/quake2xp-glsl
	media-libs/devil
	media-libs/libsdl
	media-libs/libvorbis
	>=media-libs/openal-1.14
	virtual/opengl"

NO_WAF_LIBDIR="1"

src_prepare() {
	epatch \
		${FILESDIR}/quake2xp-9999-wscript.patch
}

src_configure() {
	waf-utils_src_configure
}

src_install() {
	waf-utils_src_install
	newicon linux/q2icon.xbm quake2xp.xbm
	make_desktop_entry "quake2xp" "Quake2XP" "quake2xp" "Game;ActionGame;"
	dodoc Readme_Linux.txt

	insinto "${GAMES_DATADIR}"/${PN}/baseq2
	doins ${DISTDIR}/q2xpMusic.pkx
	doins ${DISTDIR}/q2xpMdl1.pkx
	doins ${DISTDIR}/q2xpTex0.pkx
	doins ${DISTDIR}/q2xpMdl.pkx
	doins ${DISTDIR}/q2xpCache.pkx
	doins ${DISTDIR}/q2xp0.pkx

	if use rogue; then
		insinto "${GAMES_DATADIR}"/${PN}/rogue
		doins ${DISTDIR}/q2xpR.pkx
	fi

	if use xatrix; then
		insinto "${GAMES_DATADIR}"/${PN}/xatrix
		doins ${DISTDIR}/q2xpX.pkx
		doins ${DISTDIR}/q2xpXcache.pkx
	fi

	# Setup symlinks to Quake2's data so that Quake2XP thinks Quake2 and Quake2XP data are in the same directory
	dosym ${GAMES_DATADIR}/quake2/baseq2/maps.lst ${GAMES_DATADIR}/quake2xp/baseq2/maps.lst
	dosym ${GAMES_DATADIR}/quake2/baseq2/pak0.pak ${GAMES_DATADIR}/quake2xp/baseq2/pak0.pak
	dosym ${GAMES_DATADIR}/quake2/baseq2/pak1.pak ${GAMES_DATADIR}/quake2xp/baseq2/pak1.pak
	dosym ${GAMES_DATADIR}/quake2/baseq2/pak2.pak ${GAMES_DATADIR}/quake2xp/baseq2/pak2.pak
	dosym ${GAMES_DATADIR}/quake2/baseq2/players ${GAMES_DATADIR}/quake2xp/baseq2/players

	dodir ${GAMES_DATADIR}/quake2xp/ctf
	dosym ${GAMES_DATADIR}/quake2/ctf/ctf2.ico ${GAMES_DATADIR}/quake2xp/ctf/ctf2.ico
	dosym ${GAMES_DATADIR}/quake2/ctf/pak0.pak ${GAMES_DATADIR}/quake2xp/ctf/pak0.pak
	dosym ${GAMES_DATADIR}/quake2/ctf/server.cfg ${GAMES_DATADIR}/quake2xp/ctf/server.cfg

	# TODO: symlink data for rogue and xatrix if enabled by USE flags

	prepgamesdirs
}

pkg_preinst() {
	games_pkg_preinst
}

pkg_postinst() {
	games_pkg_postinst
}
