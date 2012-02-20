# Copyright 2012 Funtoo Technologies
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

MY_P=CEGUI-${PV}
MY_D=CEGUI-DOCS-${PV}
DESCRIPTION="Crazy Eddie's GUI System"
HOMEPAGE="http://www.cegui.org.uk/"
SRC_URI="mirror://sourceforge/crayzedsgui/${MY_P}.tar.gz
	doc? ( mirror://sourceforge/crayzedsgui/${MY_D}.tar.gz )"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 -ppc ~x86"
IUSE="bidi debug +devil directfb doc examples expat gtk irrlicht lua +null-renderer ogre +opengl pcre python rapidxml \
	static-libs +stb +tga tinyxml truetype +xerces-c xml zip" # corona freeimage silly
REQUIRED_USE="|| ( expat tinyxml xerces-c xml )" # bug 362223

RDEPEND="bidi? ( dev-libs/fribidi )
	devil? ( media-libs/devil )
	examples? ( gtk? ( x11-libs/gtk+:2 )
		media-libs/jpeg )
	expat? ( dev-libs/expat )
	truetype? ( media-libs/freetype:2 )
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
	tinyxml? ( dev-libs/tinyxml )
	xerces-c? ( dev-libs/xerces-c )
	xml? ( dev-libs/libxml2 )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	doc? ( app-doc/doxygen )
	python? ( sys-apps/mlocate )"

S=${WORKDIR}/${MY_P}

pkg_setup() {
	pkg_setup

	if use directfb; then
		einfo
		einfo You have enabled the DirectFB renderer. This renderer is currently broken and incomplete.
		einfo It should only be enabled for development and/or testing purposes.
		einfo
	fi
}

src_prepare() {
	# build with newer zlib (bug #389863)
	sed -i -e '74i#define OF(x) x' cegui/src/minizip/unzip.h || die
	sed -i -e '125i#define OF(x) x' cegui/src/minizip/ioapi.h || die

	if use examples ; then
		cp -r Samples Samples.clean
		rm -f $(find Samples.clean -name 'Makefile*')
	fi
}

src_configure() {

	econf \
		$(use_enable bidi bidirectional-text) \
		--disable-corona \
		$(use_enable debug) \
		--disable-dependency-tracking \
		$(use_enable devil) \
		$(use_enable directfb directfb-renderer) \
		$(use_enable examples samples) \
		$(use_enable expat) \
		$(use_enable truetype freetype) \
		$(use_enable irrlicht irrlicht-renderer) \
		$(use_enable lua lua-module) \
		$(use_enable lua toluacegui) \
		--enable-external-toluapp \
		$(use_enable null-renderer) \
		$(use_enable ogre ogre-renderer) \
		$(use_enable opengl opengl-renderer) \
		--enable-external-glew \
		$(use_enable pcre) \
		$(use_enable python python-module) \
		$(use_enable rapidxml) \
		--enable-shared \
		--disable-silly \
		$(use_enable stb) \
		$(use_enable tga) \
		$(use_enable tinyxml) \
		--enable-external-tinyxml \
		$(use_enable xerces-c) \
		$(use_enable xml libxml) \
		$(use_enable zip minizip-resource-provider) \
		$(use_with gtk gtk2) \
		$(use_enable static-libs static)
}

src_install() {
	emake DESTDIR="${D}" install || die

	# remove .la files
	use static-libs || rm -f "${D}"/usr/*/*.la

	if use doc ; then
		emake html || die
		dohtml -r doc/doxygen/html/* || die
	fi
	if use examples ; then
		insinto /usr/share/doc/${PF}/Samples
		doins -r Samples.clean/* || die
	fi
}
