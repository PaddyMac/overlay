# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils toolchain-funcs flag-o-matic

DESCRIPTION="C++ class libraries that simplify and accelerate the development of network-centric, portable applications."
HOMEPAGE="http://pocoproject.org/"
SRC_URI="mirror://sourceforge/poco/${P}.tar.bz2
	doc? ( mirror://sourceforge/poco/${P}-all-doc.tar.gz )"
LICENSE="Boost-1.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples iodbc mysql odbc sqlite ssl test"

DEPEND="dev-libs/libpcre
	dev-libs/expat
	sys-libs/zlib
	mysql? ( virtual/mysql )
	odbc? ( iodbc? ( dev-db/libiodbc )
		!iodbc? ( dev-db/unixODBC ) )
	ssl? ( dev-libs/openssl )
	sqlite? ( dev-db/sqlite:3 )"
RDEPEND="${DEPEND}"

src_configure() {
	targets="libexecs"
	odbc="unixodbc"

	if use ssl; then
		targets="${targets} NetSSL_OpenSSL-libexec Crypto-libexec"
		echo NetSSL_OpenSSL >> components
		echo Crypto >> components
	fi
	if use odbc; then
		targets="${targets} Data/ODBC-libexec"
		echo Data/ODBC >> components
		if use iodbc; then
			append-flags "-I/usr/include/iodbc"
			odbc="iodbc"
		fi
	fi
	if use sqlite; then
		targets="${targets} Data/SQLite-libexec"
		echo Data/SQLite >> components
	fi
	if use mysql; then
		targets="${targets} Data/MySQL-libexec"
		echo Data/MySQL >> components
	fi

	if use test; then
		targets="${targets} cppunit tests"
		echo CppUnit >> components
		use ssl && targets="${targets} NetSSL_OpenSSL-tests Crypto-tests"
		use odbc && targets="${targets} Data/ODBC-tests"
		use sqlite && targets="${targets} Data/SQLite-tests"
		use mysql && targets="${targets} Data/MySQL-tests"
	fi

	local myconf
	use test || myconf="--no-tests"
	# not autoconf
	./configure \
		--no-samples ${myconf} \
		--prefix=/usr \
		--unbundled \
		|| die "configure failed"

	sed -i \
		-e "s|CC      = .*|CC      = $(tc-getCC)|" \
		-e "s|CXX     = .*|CXX     = $(tc-getCXX)|" \
		-e "s|RANLIB  = .*|RANLIB  = $(tc-getRANLIB)|" \
		-e "s|LIB     = ar|LIB     = $(tc-getAR)|" \
		-e "s|STRIP   = .*|STRIP   = /bin/true|" \
		-e "s|CFLAGS          = |CFLAGS          = ${CFLAGS}|" \
		-e "s|CXXFLAGS        = |CXXFLAGS        = ${CXXFLAGS} |" \
		-e "s|LINKFLAGS       =|LINKFLAGS       = ${LDFLAGS} |" \
		-e "s|SHAREDOPT_LINK  = -Wl,-rpath,\$(LIBPATH)|SHAREDOPT_LINK  =|" \
		-e 's|-O2||g' \
		build/config/Linux build/config/FreeBSD || die "sed failed"
	sed -i -e "s|SHLIBFLAGS)|SHLIBFLAGS) ${LDFLAGS}|" build/rules/lib || die
}

src_compile() {
	emake POCO_PREFIX=/usr GENTOO_ODBC="${odbc}" LIBDIR="$(get_libdir)" ${targets} || die "emake failed"
}

src_install() {
	emake POCO_PREFIX=/usr LIBDIR="$(get_libdir)" DESTDIR="${D}" install || die "emake install failed"

	dodoc CHANGELOG CONTRIBUTORS NEWS README

	use doc && dohtml -r "${WORKDIR}/${MY_DOCP}"/*

	if use examples ; then
		for d in Net XML Data Util NetSSL_OpenSSL Foundation ; do
			insinto /usr/share/doc/${PF}/examples/${d}
			doins -r ${d}/samples
		done
		find "${D}/usr/share/doc/${PF}/examples" \
			-iname "*.sln" -or -iname "*.vcproj" -or \
			-iname "*.vmsbuild" -or -iname "*.properties" \
			| xargs rm
	fi
}
