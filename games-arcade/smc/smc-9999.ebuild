# Copyright 2012 Funtoo Technologies
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-arcade/smc/smc-1.9.ebuild,v 1.5 2011/04/27 16:39:06 mr_bones_ Exp $

EAPI=3
inherit autotools eutils flag-o-matic git-2 games

MUSIC_P=SMC_Music_5.0_high
DESCRIPTION="Secret Maryo Chronicles"
HOMEPAGE="http://www.secretmaryo.org/"
SRC_URI="music? ( mirror://sourceforge/smclone/${MUSIC_P}.zip )"
EGIT_REPO_URI="git://github.com/FluXy/SMC.git
	https://github.com/FluXy/SMC.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="music +nls"

RDEPEND=">=dev-games/cegui-0.7.4[opengl,devil]
	>=dev-libs/boost-1.44
	virtual/opengl
	virtual/glu
	dev-libs/libpcre[unicode]
	media-libs/libpng
	media-libs/libsdl[X,joystick,opengl]
	media-libs/sdl-image[png]
	media-libs/sdl-mixer[vorbis]
	media-libs/sdl-ttf"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	music? ( app-arch/unzip )
	sys-devel/gettext"

S="${WORKDIR}/${PN}"

EGIT_SOURCEDIR="${WORKDIR}"

src_unpack() {
	git-2_src_unpack

	if use music; then
		cd ${S}
		unpack ${MUSIC_P}.zip
	fi

	# The default filesystem version is 3 for Boost 1.46 and higher, but this line should specify version 3 in case end users are using Boost 1.44 or 1.45.
	append-flags -DBOOST_FILESYSTEM_VERSION=3
}

src_prepare() {

	mkdir -p m4
	cp -f /usr/share/gettext/config.rpath .

	eautoreconf
}

src_configure() {

	egamesconf \
		
		$(use_enable nls)

}

src_install() {
	emake DESTDIR="${D}" install || die
	newicon data/icon/window_32.png smc.png
	make_desktop_entry "${PN}" "Secret Maryo Chronicles" "${PN}" "Game;ArcadeGame;"
	doman makefiles/unix/man/smc.6
	dohtml docs/{*.css,*.html}
	prepgamesdirs
}
