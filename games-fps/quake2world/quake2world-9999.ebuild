# Distributed under the terms of the GNU General Public License v2

EAPI=4

inherit autotools games subversion

DESCRIPTION="Quake2World is a Free, standalone first person shooter video game."
HOMEPAGE="http://quake2world.net/"
SRC_URI=""
ESVN_REPO_URI="svn://quake2world.net/quake2world/trunk"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="curses debug dedicated doc master mysql profiling tools"

DEPEND="media-libs/libsdl
	media-libs/sdl-image
	media-libs/sdl-mixer
	net-misc/curl
	sys-libs/zlib
	virtual/jpeg
	curses? ( sys-libs/ncurses )
	doc? ( app-doc/doxygen )
	mysql? ( virtual/mysql )"
RDEPEND="games-fps/quake2world-data
	media-libs/libsdl
	media-libs/sdl-image
	media-libs/sdl-mixer
	net-misc/curl
	sys-libs/zlib
	virtual/jpeg 
	curses? ( sys-libs/ncurses )
	mysql? ( virtual/mysql )"

ESVN_BOOTSTRAP="eautoreconf"

src_prepare() {
	sed -i 's|$prefix/lib|$libdir|' configure.in
	sed -i 's|$prefix/share|$datadir|' configure.in
	subversion_src_prepare
}

src_configure() {

	local myconf
	if use dedicated; then
		myconf="--without-client"
	else
		myconf="--with-client"
	fi

	egamesconf \
		--bindir=${GAMES_BINDIR}
		$(use_with curses) \
		$(use_enable debug) \
		$(use_with master) \
		$(use_with mysql) \
		$(use_enable profiling profile) \
		$(use_with tools) \
		${myconf}
}
