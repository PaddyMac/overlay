# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils versionator gnome2-utils games

MY_PV=$(get_major_version)
MY_BUILD=$(get_after_major_version)

DESCRIPTION="Port of Duke Nukem 3D for SDL"
HOMEPAGE="http://www.eduke32.com"
SRC_URI="http://dukeworld.duke4.net/${PN}/synthesis/${MY_PV}-${MY_BUILD}/${PN}_src_${MY_PV}-${MY_BUILD}.tar.bz2"

LICENSE="BUILD GPL-2"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="+asm cxx cdinstall clang debug demo extras gtk lunatic +network +opengl +png +polymer tools +vpx"
REQUIRED_USE="polymer? ( opengl ) vpx? ( opengl )"

COMMON_DEPEND="media-libs/flac
		media-libs/libogg
		media-libs/libsdl:0[joystick,sound,video]
		media-libs/libvorbis
		media-libs/sdl-mixer:0[timidity]
		gtk? ( x11-libs/gtk+:2 )
		lunatic? ( dev-lang/luajit:2 )
		opengl? ( media-libs/libsdl[opengl]
			virtual/glu
			virtual/opengl )
		png? ( media-libs/libpng
			sys-libs/zlib )
		vpx? ( media-libs/libvpx )"
DEPEND="${COMMON_DEPEND}
	media-libs/libicns
	asm? ( x86? ( dev-lang/nasm ) )
	clang? ( sys-devel/clang )"
RDEPEND="${COMMON_DEPEND}
	cdinstall? ( games-fps/duke3d-data )
	demo? ( games-fps/duke3d-demodata )
	extras? ( games-fps/eduke32-extras )"

S=${WORKDIR}/${PN}_${MY_PV}-${MY_BUILD}

src_unpack() {
	unpack "${PN}_src_${MY_PV}-${MY_BUILD}.tar.bz2"
}

src_prepare() {
	if use cxx; then
		#Remove -Wno-pointer-sign from cflags when building with C++
		epatch ${FILESDIR}/${PN}-20130128.3443-cxx.patch
	fi

	#Change all references to "luajit" to "luajit-2"
	epatch ${FILESDIR}/${PN}-20130128.3443-luajit-2.patch

	#Remove mandatory optimization flags and CC/CXX settings, and add flags from Make.conf
	epatch ${FILESDIR}/${PN}-20130128.3443-respect-cflags.patch

	# Point eduke32 to data files in shared duke3d folder.
	# Multiple search paths can be defined so that, with the default configuration as of
	# the 20130128 release, this adds /usr/share/games/duke3d in ADDITION to
	# /usr/share/games/eduke32 so that eduke32 and duke3d's base data can be kept separate.
	sed -e "s;/usr/local/share/games/eduke32;${GAMES_DATADIR}/duke3d;" -i source/astub.c || die "sed astub.c path update failed"
	sed -e "s;/usr/local/share/games/eduke32;${GAMES_DATADIR}/duke3d;" -i source/game.c || die "sed game.c path update failed"

	# Redirect log file so it's not always written in $PWD
	sed -e "s;mapster32.log;${GAMES_LOGDIR}/mapster32.log;" -i source/astub.c || die "sed astub.c log fix failed"
	sed -e "s;eduke32.log;${GAMES_LOGDIR}/eduke32.log;" -i source/game.c || die "sed game.c log fix failed"

	# Ensure luajit-2 headers are found if lunatic USE flag is enabled.
	# TODO: Patch Makefile to use pkg-config.
	sed -e 's;/usr/local/include/luajit-2.0;/usr/include/luajit-2.0;' -i Makefile.common || die "sed Makefile.common luajit header path fix failed"

	# There is no "luajit" binary on Gentoo. Specify "luajit-2"
	sed -e 's;LUAJIT=luajit;LUAJIT=luajit-2;' -i Makefile.common || die "sed Makefile.common luajit binary name fix failed"
}

src_compile() {
	local MY_OPTS=(
		ARCH=
		LTO=0
		OPTLEVEL=0
		STRIP=touch
		$(usex debug "RELEASE=0" "RELEASE=1")
		$(usex asm "NOASM=0" "NOASM=1")
		$(usex cxx "CPLUSPLUS=1" "CPLUSPLUS=0")
		$(usex clang "CLANG=1" "CLANG=0")
		$(usex gtk "LINKED_GTK=1" "LINKED_GTK=0")
		$(usex lunatic "LUNATIC=1" "LUNATIC=0")
		$(usex network "NETCODE=1" "NETCODE=0")
		$(usex opengl "USE_OPENGL=1" "USE_OPENGL=0")
		$(usex png "USE_LIBPNG=1" "USE_LIBPNG=0")
		$(usex polymer "POLYMER=1" "POLYMER=0")
		$(usex vpx "USE_LIBVPX=1" "USE_LIBVPX=0")
	)

	emake ${MY_OPTS[@]}
 
	if use tools; then
		emake -C build ${MY_OPTS[@]}
	fi

}

src_install() {

	dogamesbin eduke32 mapster32

	insinto "${GAMES_DATADIR}/${PN}"
	doins package/{SEHELP.HLP,STHELP.HLP,m32help.hlp,names.h,tiles.cfg}
	doins -r package/samples

	# Eduke32 doesn't provide Linux-friendly icons, so we're extracting the MacOS icons.
	icns2png -x ${S}/Apple/bundles/EDuke32.app/Contents/Resources/eduke32.icns || die "Extracting icons from eduke32.icns"
	icns2png -x ${S}/Apple/bundles/Mapster32.app/Contents/Resources/mapster32.icns || die "Extracting icons from mapster32.icns"

	local i
	for i in 16 32 128 256 ; do
		newicon -s ${i} eduke32_${i}x${i}x32.png eduke32.png
		newicon -s ${i} mapster32_${i}x${i}x32.png mapster32.png
	done

	make_desktop_entry ${PN} EDuke32 ${PN}
	make_desktop_entry mapster32 Mapster32 mapster32

	if use tools; then
		dobin build/{arttool,bsuite,cacheinfo,generateicon,givedepth,kextract,kgroup,kmd2tool,md2tool,mkpalette,transpal,unpackssi,wad2art,wad2map}
		dodoc build/doc/*.txt
	fi

	dodoc build/buildlic.txt

	dodir ${GAMES_LOGDIR}

	prepgamesdirs
}

pkg_preinst() {
	games_pkg_preinst
	gnome2_icon_savelist
}

pkg_postinst() {
	games_pkg_postinst
	gnome2_icon_cache_update

	use cdinstall || use demo || {
		echo
		ewarn "Note: You must also install the game data files, either manually or with"
		ewarn "games-fps/duke3d-data or games-fps/duke3d-demodata before playing."
		echo
	}

	einfo
	elog "${PN} reads data files from ${GAMES_DATADIR}/duke3d"
	einfo

	[[ -e ${ROOT}/${GAMES_LOGDIR} ]] || mkdir -p "${ROOT}/${GAMES_LOGDIR}"
	touch "${ROOT}/${GAMES_LOGDIR}"/${PN}.log
	touch "${ROOT}/${GAMES_LOGDIR}"/mapster32.log
	chown ${GAMES_USER}:${GAMES_GROUP} "${ROOT}/${GAMES_LOGDIR}"/${PN}.log
	chown ${GAMES_USER}:${GAMES_GROUP} "${ROOT}/${GAMES_LOGDIR}"/mapster32.log
	chmod g+w "${ROOT}/${GAMES_LOGDIR}"/${PN}.log
	chmod g+w "${ROOT}/${GAMES_LOGDIR}"/mapster32.log
}

pkg_postrm() {
        gnome2_icon_cache_update
}
