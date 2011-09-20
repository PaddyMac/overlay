# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
inherit multilib eutils cmake-utils mercurial

MY_PV="${PV//./-}"
DESCRIPTION="Object-oriented Graphics Rendering Engine"
HOMEPAGE="http://www.ogre3d.org/"
EHG_REPO_URI="http://bitbucket.org/sinbad/ogre/"
EHG_REVISION="v1-7"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+boost +boost-threads doc cg double-precision examples +freeimage +ois +opengl poco-threads test tbb-threads tools +zip"
RESTRICT="test" #139905

RDEPEND="media-libs/freetype:2
	virtual/opengl
	virtual/glu
	x11-libs/libX11
	x11-libs/libXaw
	x11-libs/libXrandr
	x11-libs/libXt
	boost? ( dev-libs/boost )
	boost-threads? ( dev-libs/boost )
	cg? ( media-gfx/nvidia-cg-toolkit )
	freeimage? ( media-libs/freeimage )
	ois? ( dev-games/ois )
	poco-threads? ( dev-libs/poco )
	tbb-threads? ( dev-cpp/tbb )
	zip? ( sys-libs/zlib dev-libs/zziplib )"
DEPEND="${RDEPEND}
	x11-proto/xf86vidmodeproto
	dev-util/pkgconfig
	doc? ( app-doc/doxygen )
	test? ( dev-util/cppunit )"

S="${WORKDIR}/${PN}"

src_unpack() {
	mercurial_src_unpack
}

src_prepare() {
	epatch "${FILESDIR}/${P}-gcc46.patch"
	if use doc; then
		sed -i -e "s:share/OGRE/docs:share/doc/${P}:" \
			Docs/CMakeLists.txt || die "sed failed"
	fi
}

src_configure() {
	#-DOGRE_STATIC=ON
	local mycmakeargs="
		-DOGRE_LIB_DIRECTORY="$(get_libdir)"
		$(cmake-utils_use boost OGRE_USE_BOOST)
		$(cmake-utils_use cg OGRE_BUILD_PLUGIN_CG)
		$(cmake-utils_use double-precision OGRE_CONFIG_DOUBLE)
		$(cmake-utils_use doc OGRE_INSTALL_DOCS)
		$(cmake-utils_use examples OGRE_INSTALL_SAMPLES)
		$(cmake-utils_use freeimage OGRE_CONFIG_ENABLE_FREEIMAGE)
		$(cmake-utils_use opengl OGRE_BUILD_RENDERSYSTEM_GL)
		$(cmake-utils_use test OGRE_BUILD_TESTS)
		$(cmake-utils_use tools OGRE_BUILD_TOOLS)
		$(cmake-utils_use zip OGRE_CONFIG_ENABLE_ZIP)"

	use cg && [ -d /opt/nvidia-cg-toolkit ] && ogre_dynamic_config+="-DCg_HOME=/opt/nvidia-cg-toolkit"
	use freeimage && LDFLAGS="$LDFLAGS $(pkg-config --libs freeimage)"

	if use boost-threads; then
		einfo "Enabling boost as Threading provider"
		mycmakeargs="${mycmakeargs} -DOGRE_CONFIG_THREADS=ON -DOGRE_CONFIG_THREAD_PROVIDER=\"boost\""
	elif use poco-threads; then
		einfo "Enabling poco as Threading provider"
	    mycmakeargs="${mycmakeargs} -DOGRE_CONFIG_THREADS=ON -DOGRE_CONFIG_THREAD_PROVIDER=\"poco\""
	elif use tbb-threads; then
		einfo "Enabling tbb as Threading provider"
	    mycmakeargs="${mycmakeargs} -DOGRE_CONFIG_THREADS=ON -DOGRE_CONFIG_THREAD_PROVIDER=\"tbb\""
	else
		echo
		ewarn "Threading support is disabled!"
		echo
		mycmakeargs="${mycmakeargs} -DOGRE_CONFIG_THREADS=OFF"
	fi
	CMAKE_BUILD_TYPE="Release"
	cmake-utils_src_configure
}
