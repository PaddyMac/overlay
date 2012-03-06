# Copyright 2012 Funtoo Technologies
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
inherit multilib eutils cmake-utils mercurial

MY_PV="${PV//./-}"
DESCRIPTION="Object-oriented Graphics Rendering Engine"
HOMEPAGE="http://www.ogre3d.org/"
EHG_REPO_URI="http://bitbucket.org/sinbad/ogre/"
EHG_REVISION="v1-8"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+boost +boost-threads +bsp debug doc cg +dds double-precision examples +freeimage nedmalloc +octree +opengl +paging +particlefx +pcz poco-threads +pooling \
	profiling +property pvrtc +rtshader +scriptcompiler source static +stl string tbb-threads +terrain test +threading tools tracker unity viewport +zip"
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
	dev-games/ois
	poco-threads? ( dev-libs/poco )
	zip? ( sys-libs/zlib dev-libs/zziplib )
	tbb-threads? ( dev-cpp/tbb )"
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
	if use doc; then
		sed -i -e "s:share/OGRE/docs:share/doc/${P}:" \
			Docs/CMakeLists.txt || die "sed failed"
	fi
}

src_configure() {

	# CMAKE_BUILD_TYPE must be Release. If it is Gentoo, the shared libraries will not be installed.
	CMAKE_BUILD_TYPE=Release

	local mycmakeargs=(
		"-DOGRE_LIB_DIRECTORY=$(get_libdir)"
		$(cmake-utils_use boost OGRE_USE_BOOST)
		$(cmake-utils_use bsp OGRE_BUILD_PLUGIN_BSP)
		$(cmake-utils_use cg OGRE_BUILD_PLUGIN_CG)
		$(cmake-utils_use debug CMAKE_VERBOSE_MAKEFILE)
		$(cmake-utils_use dds OGRE_CONFIG_ENABLE_DDS)
		$(cmake-utils_use double-precision OGRE_CONFIG_DOUBLE)
		$(cmake-utils_use doc OGRE_INSTALL_DOCS)
		$(cmake-utils_use examples OGRE_INSTALL_SAMPLES)
		$(cmake-utils_use freeimage OGRE_CONFIG_ENABLE_FREEIMAGE)
		$(cmake-utils_use octree OGRE_BUILD_PLUGIN_OCTREE)
		$(cmake-utils_use opengl OGRE_BUILD_RENDERSYSTEM_GL)
		$(cmake-utils_use paging OGRE_BUILD_COMPONENT_PAGING)
		$(cmake-utils_use particlefx OGRE_BUILD_PLUGIN_PFX)
		$(cmake-utils_use pcz OGRE_BUILD_PLUGIN_PCZ)
		$(cmake-utils_use profiling OGRE_PROFILING)
		$(cmake-utils_use property OGRE_BUILD_COMPONENT_PROPERTY)
		$(cmake-utils_use pvrtc OGRE_CONFIG_ENABLE_PVRTC)
		$(cmake-utils_use rtshader OGRE_BUILD_COMPONENT_RTSHADERSYSTEM)
		$(cmake-utils_use rtshader OGRE_BUILD_RTSHADERSYSTEM_CORE_SHADERS)
		$(cmake-utils_use rtshader OGRE_BUILD_RTSHADERSYSTEM_EXT_SHADERS)
		$(cmake-utils_use scriptcompiler OGRE_CONFIG_NEW_COMPILERS)
		$(cmake-utils_use source OGRE_INSTALL_SAMPLES_SOURCE)
		$(cmake-utils_use static OGRE_STATIC)
		$(cmake-utils_use stl OGRE_CONFIG_CONTAINERS_USE_CUSTOM_ALLOCATOR)
		$(cmake-utils_use string OGRE_CONFIG_STRING_USE_CUSTOM_ALLOCATOR)
		$(cmake-utils_use terrain OGRE_BUILD_COMPONENT_TERRAIN)
		$(cmake-utils_use test OGRE_BUILD_TESTS)
		$(cmake-utils_use tools OGRE_BUILD_TOOLS)
		$(cmake-utils_use tools OGRE_INSTALL_TOOLS)
		$(cmake-utils_use tracker OGRE_CONFIG_MEMTRACK_DEBUG)
		$(cmake-utils_use tracker OGRE_CONFIG_MEMTRACK_RELEASE)
		$(cmake-utils_use unity OGRE_UNITY_BUILD)
		$(cmake-utils_use viewport OGRE_CONFIG_ENABLE_VIEWPORT_ORIENTATIONMODE)
		$(cmake-utils_use zip OGRE_CONFIG_ENABLE_ZIP)
	)

	use cg && [ -d /opt/nvidia-cg-toolkit ] && ogre_dynamic_config+="-DCg_HOME=/opt/nvidia-cg-toolkit"

	use freeimage && LDFLAGS="$LDFLAGS $(pkg-config --libs freeimage)"


	# Determine memory allocator to use.
	if use pooling; then
		einfo "Enabling nedmalloc with pooling as the memory allocator."
		mycmakeargs+=(
			"-DOGRE_CONFIG_ALLOCATOR=4"
		)
	elif use nedmalloc; then
		einfo "Enabling nedmalloc as the memory allocator."
		mycmakeargs+=(
			"-DOGRE_CONFIG_ALLOCATOR=2"
		)
	else
		einfo "Enabling standard memory allocator."
		mycmakeargs+=(
			"-DOGRE_CONFIG_ALLOCATOR=1"
		)
	fi

        # Determine threading provider and threading strategy to use.
        if use boost-threads; then
                if use threading; then
                        einfo "Enabling boost as Threading provider"
                        einfo "Setting Ogre thread support for background loading to: Background resource preparation."
                        mycmakeargs+=(
                                "-DOGRE_CONFIG_THREAD_PROVIDER=boost"
                                "-DOGRE_CONFIG_THREADS=2"
                        )
                else
                        einfo "Enabling boost as Threading provider"
                        einfo "Setting Ogre thread support for background loading to: Full background loading."
                        mycmakeargs+=(
                                "-DOGRE_CONFIG_THREAD_PROVIDER=boost"
                                "-DOGRE_CONFIG_THREADS=1"
                        )
                fi
        elif use poco-threads; then
                if use threading; then
                        einfo "Enabling poco as Threading provider"
                        einfo "Setting Ogre thread support for background loading to: Background resource preparation."
                        mycmakeargs+=(
                                "-DOGRE_CONFIG_THREAD_PROVIDER=poco"
                                "-DOGRE_CONFIG_THREADS=2"
                        )
                else
                        einfo "Enabling poco as Threading provider"
                        einfo "Setting Ogre thread support for background loading to: Full background loading."
                        mycmakeargs+=(
                                "-DOGRE_CONFIG_THREAD_PROVIDER=poco"
                                "-DOGRE_CONFIG_THREADS=1"
                        )
                fi
        elif use tbb-threads; then
                if use threading; then
                        einfo "Enabling tbb as Threading provider"
                        einfo "Setting Ogre thread support for background loading to: Background resource preparation."
                        mycmakeargs+=(
                                "-DOGRE_CONFIG_THREAD_PROVIDER=tbb"
                                "-DOGRE_CONFIG_THREADS=2"
                        )
                else
                        einfo "Enabling poco as Threading provider"
                        einfo "Setting Ogre thread support for background loading to: Full background loading."
                        mycmakeargs+=(
                                "-DOGRE_CONFIG_THREAD_PROVIDER=poco"
                                "-DOGRE_CONFIG_THREADS=1"
                        )
                fi
	else
		echo
		ewarn "Ogre thread support for background loading is disabled!"
		echo
		mycmakeargs+=(
			"-DOGRE_CONFIG_THREADS=0"
		)
	fi

	cmake-utils_src_configure
}
