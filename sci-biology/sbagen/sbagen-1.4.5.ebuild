# Copyright 2008-2012 Funtoo Technologies
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit eutils
inherit flag-o-matic
inherit toolchain-funcs

DESCRIPTION="Command line sequenced binaural beat generator"
HOMEPAGE="http://sbagen.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 amd64"

IUSE="+examples mp3 +scripts +sounds +vorbis"

DEPEND="mp3? ( media-libs/libmad )
	vorbis? ( media-libs/libogg
		media-libs/tremor )"

src_prepare() {
	epatch "${FILESDIR}"/${P}-library-path.patch
}

src_compile() {

	if use vorbis; then
		append-cppflags -DOGG_DECODE
		LIBS="-logg -lvorbisidec "
	fi

	if use mp3; then
		append-cppflags -DMP3_DECODE
		LIBS="${LIBS} -lmad"
	fi

	$(tc-getCC) ${CFLAGS} -DT_LINUX -lm -lpthread ${LDFLAGS} sbagen.c -L${libdir} ${LIBS} -o sbagen || die "Sbagen: compilation failed"
}

src_install() {

	exeinto /usr/bin
	doexe sbagen

	if use scripts; then
		doexe scripts/*
	fi

	if use examples; then
		doins -r examples/
	fi

	if use vorbis && use sounds; then
		doins river1.ogg river2.ogg
	fi

	dodoc ChangeLog.txt focus.txt focus2.txt holosync.txt README.txt SBAGEN.txt theory.txt theory2.txt TODO.txt wave.txt
}


