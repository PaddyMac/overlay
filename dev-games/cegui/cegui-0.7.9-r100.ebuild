# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit eutils

MY_P=CEGUI-${PV}
MY_D=CEGUI-DOCS-${PV}
DESCRIPTION="Crazy Eddie's GUI System"
HOMEPAGE="http://www.cegui.org.uk/"
SRC_URI="mirror://sourceforge/crayzedsgui/${MY_P}.tar.gz
	doc? ( mirror://sourceforge/crayzedsgui/${MY_D}.tar.gz )"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 -ppc ~x86"
IUSE="bidi debug devil directfb doc examples expat freeimage gtk irrlicht lua +null ogre opengl \
	pcre python rapidxml silly static-libs stb tga tinyxml truetype xerces-c +xml zip" # corona
REQUIRED_USE="|| ( expat rapidxml tinyxml xerces-c xml )" # bug 362223

RDEPEND="bidi? ( dev-libs/fribidi )
	devil? ( media-libs/devil )
	directfb? ( dev-libs/DirectFB )
	expat? ( dev-libs/expat )
	freeimage? ( media-libs/freeimage )
	gtk? ( x11-libs/gtk+:2 )
	irrlicht? ( dev-games/irrlicht )
	lua? (
		dev-lang/lua
		dev-lua/toluapp
	)
	ogre? ( >=dev-games/ogre-1.7.1 )
	opengl? (
		virtual/opengl
		virtual/glu
		media-libs/freeglut
		media-libs/glew
	)
	pcre? ( dev-libs/libpcre )
	python? ( || ( dev-lang/python:2.6
			dev-lang/python:2.7 )
		)
	rapidxml? ( dev-libs/rapidxml )
	silly? ( media-libs/silly )
	tinyxml? ( dev-libs/tinyxml )
	truetype? ( media-libs/freetype:2 )
	xerces-c? ( dev-libs/xerces-c )
	xml? ( dev-libs/libxml2 )
	zip? ( sys-libs/zlib[minizip] )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( app-doc/doxygen )
	python? ( sys-apps/mlocate )"

S=${WORKDIR}/${MY_P}
S2=${WORKDIR}/${MY_P}_static

pkg_setup() {

	if use directfb; then
		einfo
		einfo "You have enabled the DirectFB renderer. This renderer is currently broken and incomplete."
		einfo "It should only be enabled for development and/or testing purposes."
		einfo
	fi
}

src_prepare() {
	# use minizip from zlib rather than local code
	if use zip ; then
		sed -i \
			-e '/CEGUI_BUILD_MINIZIP_RESOURCE_PROVIDER_TRUE/{
					s:minizip/ioapi.cpp minizip/unzip.cpp::;
					s:libCEGUIBase@cegui_bsfx@_la-ioapi.lo::;
					s:libCEGUIBase@cegui_bsfx@_la-unzip.lo::
				}' \
			-e '/^ZLIB_LIBS/s:=.*:= -lminizip:' \
			cegui/src/Makefile.in || die
	fi
	rm -rf cegui/src/minizip

	if use examples ; then
		cp -r Samples Samples.clean
		rm -f $(find Samples.clean -name 'Makefile*')
	fi

	if use static-libs ; then
		cp -a "${S}" "${S2}" || die
	fi
}

src_configure() {
	local myconf=(
		$(use_enable bidi bidirectional-text)
		--disable-corona
		$(use_enable debug)
		$(use_enable devil)
		$(use_enable examples samples)
		$(use_enable expat)
		$(use_enable freeimage)
		$(use_with gtk gtk2)
		$(use_enable truetype freetype)
		$(use_enable irrlicht irrlicht-renderer)
		$(use_enable lua lua-module)
		$(use_enable lua toluacegui)
		--enable-external-toluapp
		$(use_enable null null-renderer)
		$(use_enable ogre ogre-renderer)
		$(use_enable opengl opengl-renderer)
		--enable-external-glew
		$(use_enable pcre)
		$(use_enable python python-module)
		$(use_enable rapidxml)
		$(use_enable silly)
		$(use_enable stb)
		$(use_enable tga)
		$(use_enable tinyxml)
		--enable-external-tinyxml
		$(use_enable xerces-c)
		$(use_enable xml libxml)
		$(use_enable zip minizip-resource-provider)
	)

	econf \
		"${myconf[@]}" \
		--disable-static \
		--enable-shared

	if use static-libs ; then
		cd "${S2}" || die
		econf \
			"${myconf[@]}" \
			--enable-static \
			--disable-shared
	fi

	# we are doing a double build here cause
	# the build system does not permit
	# "--enable-static --enable-shared"
}

src_compile() {
	default

	if use static-libs ; then
		emake -C "${S2}"
	fi
}

src_install() {
	local i
	default

	if use doc ; then
		emake html || die
		dohtml -r doc/doxygen/html/* || die
	fi
	if use examples ; then
		insinto /usr/share/doc/${PF}/Samples
		doins -r Samples.clean/* || die
	fi

	if use static-libs ; then
		find "${S2}" -name "*CEGUI*.a" -exec dolib.a '{}' \;

		# fix/merge .la files
		for i in `find "${D}" -name "*.la"` ; do
			sed \
				-e "s/old_library=''/old_library='$(basename ${i%.la}).a'/" \
				-i ${i} || die "fixing .la files failed"
		done
	else
		# remove .la files
		prune_libtool_files --all
	fi
}
