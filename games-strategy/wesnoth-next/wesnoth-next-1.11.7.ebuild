# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-strategy/wesnoth/wesnoth-1.10.7.ebuild,v 1.4 2013/11/13 11:25:08 chainsaw Exp $

EAPI=5
inherit cmake-utils eutils multilib toolchain-funcs flag-o-matic games

DESCRIPTION="Battle for Wesnoth - A fantasy turn-based strategy game"
HOMEPAGE="http://www.wesnoth.org/"
SRC_URI="mirror://sourceforge/wesnoth/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc ~ppc64 ~x86 ~x86-fbsd"
IUSE="dbus debug dedicated doc fribidi lowmem nls openmp server test tools"

RDEPEND=">=media-libs/libsdl-1.2.7:0[joystick,video,X]
	media-libs/sdl-net
	!dedicated? (
		>=media-libs/sdl-ttf-2.0.8
		>=media-libs/sdl-mixer-1.2[vorbis]
		>=media-libs/sdl-image-1.2[jpeg,png]
		dbus? ( sys-apps/dbus )
		sys-libs/zlib
		x11-libs/pango
		dev-lang/lua
		media-libs/fontconfig
	)
	>=dev-libs/boost-1.36
	virtual/libintl"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	sys-devel/gettext
	fribidi? ( dev-libs/fribidi )
	openmp? ( sys-cluster/openmpi )"

S="${WORKDIR}/wesnoth"

src_prepare() {
	if use dedicated || use server ; then
		sed \
			-e "s:GAMES_BINDIR:${GAMES_BINDIR}:" \
			-e "s:GAMES_STATEDIR:${GAMES_STATEDIR}:" \
			-e "s/GAMES_USER_DED/${GAMES_USER_DED}/" \
			-e "s/GAMES_GROUP/${GAMES_GROUP}/" "${FILESDIR}"/wesnothd-next.rc \
			> "${T}"/wesnothd-next || die
	fi

	if ! use doc ; then
		sed -i \
			-e '/manual/d' \
			doc/CMakeLists.txt || die
	fi

	# how do I hate boost? Let me count the ways...
	local boost_ver=$(best_version ">=dev-libs/boost-1.36")

	boost_ver=${boost_ver/*boost-/}
	boost_ver=${boost_ver%.*}
	boost_ver=${boost_ver/./_}

	einfo "Using boost version ${boost_ver}"
	append-cxxflags \
		-I/usr/include/boost-${boost_ver}
	append-ldflags \
		-L/usr/$(get_libdir)/boost-${boost_ver}
	export BOOST_INCLUDEDIR="/usr/include/boost-${boost_ver}"
	export BOOST_LIBRARYDIR="/usr/$(get_libdir)/boost-${boost_ver}"

	# bug #472994
	mv icons/wesnoth-icon-Mac.png icons/wesnoth-next-icon.png || die
	mv icons/map-editor-icon-Mac.png icons/wesnoth_editor-next-icon.png || die

	# respect LINGUAS (bug #483316)
	if [[ ${LINGUAS+set} ]] ; then
		local langs
		for lang in $(cat po/LINGUAS)
		do
			has $lang $LINGUAS && langs+="$lang "
		done
		echo "$langs" > po/LINGUAS || die
	fi

	# Edit .desktop files to point to binaries with "-next" suffix.
	sed -i -e "/^Icon=/s:wesnoth-icon:wesnoth-next-icon:" icons/wesnoth.desktop
	sed -i -e "/^Exec=/s:wesnoth:wesnoth-next:" icons/wesnoth.desktop
	sed -i -e "/^Icon=/s:wesnoth_editor-icon:wesnoth_editor-next-icon:" icons/wesnoth_editor.desktop
	sed -i -e "/^Exec=/s:wesnoth -e:wesnoth-next -e:" icons/wesnoth_editor.desktop

	# Rename .desktop files with "-next" suffix.
	mv icons/wesnoth.desktop icons/wesnoth-next.desktop
	mv icons/wesnoth_editor.desktop icons/wesnoth_editor-next.desktop

	# Edit CMakeLists.txt to install renamed .desktop and icons files.
	sed -i -e "s:install(FILES icons/wesnoth.desktop DESTINATION \${DESKTOPDIR} ):install(FILES icons/wesnoth-next.desktop DESTINATION \${DESKTOPDIR} ):" \
		CMakeLists.txt
	sed -i -e "s:install(FILES icons/wesnoth-icon.png DESTINATION \${ICONDIR} ):install(FILES icons/wesnoth-next-icon.png DESTINATION \${ICONDIR} ):" \
		CMakeLists.txt
	sed -i -e "s:install(FILES icons/wesnoth_editor.desktop DESTINATION \${DESKTOPDIR} ):install(FILES icons/wesnoth_editor-next.desktop DESTINATION \${DESKTOPDIR} ):" \
		CMakeLists.txt
	sed -i -e "s:install(FILES icons/wesnoth_editor-icon.png DESTINATION \${ICONDIR} ):install(FILES icons/wesnoth_editor-next-icon.png DESTINATION \${ICONDIR} ):" \
		CMakeLists.txt

	# Rename man pages with "-next" suffix.
	cd ${S}/doc/man
	mv wesnoth.6 wesnoth-next.6
	mv wesnothd.6 wesnothd-next.6
	local i
		for i in cs de en_GB es et fi fr gl hu id it ja lt pl pt pt_BR ru sk sr sr@ijekavian sr@ijekavianlatin sr@latin tr uk vi zh_CN zh_TW ; do
			cd ${i}
			mv wesnoth.6 wesnoth-next.6
			mv wesnothd.6 wesnothd-next.6
			cd ..
		done
	cd ${S}

	# Edit doc/man/CMakeLists.txt to install renamed man pages.
	sed -i -e "s:set(MANPAGES \${MANPAGES} wesnoth.6):set(MANPAGES \${MANPAGES} wesnoth-next.6):" doc/man/CMakeLists.txt
	sed -i -e "s:set(MANPAGES \${MANPAGES} wesnothd.6):set(MANPAGES \${MANPAGES} wesnothd-next.6):" doc/man/CMakeLists.txt
	sed -i -e "s:set(ALL_MANPAGES wesnoth.6 wesnothd.6):set(ALL_MANPAGES wesnoth-next.6 wesnothd-next.6):" doc/man/CMakeLists.txt
	sed -i -e "s:\${CMAKE_CURRENT_SOURCE_DIR}/wesnoth.6:\${CMAKE_CURRENT_SOURCE_DIR}/wesnoth-next.6:" doc/man/CMakeLists.txt
	sed -i -e "s:\${CMAKE_CURRENT_SOURCE_DIR}/wesnothd.6:\${CMAKE_CURRENT_SOURCE_DIR}/wesnothd-next.6:" doc/man/CMakeLists.txt
}

src_configure() {
	filter-flags -ftracer -fomit-frame-pointer
	if [[ $(gcc-major-version) -eq 3 ]] ; then
		filter-flags -fstack-protector
		append-flags -fno-stack-protector
	fi
	if use dedicated || use server ; then
		mycmakeargs=(
			"-DENABLE_CAMPAIGN_SERVER=TRUE"
			"-DENABLE_SERVER=TRUE"
			"-DSERVER_UID=${GAMES_USER_DED}"
			"-DSERVER_GID=${GAMES_GROUP}"
			"-DFIFO_DIR=${GAMES_STATEDIR}/run/wesnothd-next"
			)
	else
		mycmakeargs=(
			"-DENABLE_CAMPAIGN_SERVER=FALSE"
			"-DENABLE_SERVER=FALSE"
			)
	fi
	mycmakeargs+=(
		$(cmake-utils_use_enable !dedicated GAME)
		$(cmake-utils_use_enable !dedicated ENABLE_DESKTOP_ENTRY)
		$(cmake-utils_use_enable nls NLS)
		$(cmake-utils_use_enable dbus NOTIFICATIONS)
		$(cmake-utils_use_enable debug DEBUG_WINDOW_LAYOUT)
		$(cmake-utils_use_enable fribidi FRIBIDI)
		$(cmake-utils_use_enable lowmem LOW_MEM)
		$(cmake-utils_use_enable openmp OMP)
		$(cmake-utils_use_enable test TESTS)
		$(cmake-utils_use_enable tools TOOLS)
		"-DBINARY_SUFFIX=-next"
		"-DCMAKE_VERBOSE_MAKEFILE=TRUE"
		"-DENABLE_STRICT_COMPILATION=FALSE"
		"-DCMAKE_INSTALL_PREFIX=${GAMES_PREFIX}"
		"-DDATADIRNAME=wesnoth-next"
		"-DDATAROOTDIR=${GAMES_DATADIR}"
		"-DBINDIR=${GAMES_BINDIR}"
		"-DICONDIR=/usr/share/pixmaps"
		"-DDESKTOPDIR=/usr/share/applications"
		"-DLOCALEDIR=/usr/share/locale"
		"-DMANDIR=/usr/share/man"
		"-DPREFERENCES_DIR=.wesnoth-next"
		"-DDOCDIR=/usr/share/doc/${PF}"
		)
	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
}

src_install() {
	DOCS="README changelog players_changelog" cmake-utils_src_install
	if use dedicated || use server; then
		keepdir "${GAMES_STATEDIR}/run/wesnothd-next"
		doinitd "${T}"/wesnothd-next || die
	fi
	prepgamesdirs
}
