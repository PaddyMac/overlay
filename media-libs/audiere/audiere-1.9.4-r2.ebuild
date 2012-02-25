# Copyright 2012 Funtoo Technologies
# Distributed under the terms of the GNU General Public License v2
# $Header: $

WANT_AUTOMAKE="latest"
WANT_AUTOCONF="latest"

inherit autotools eutils flag-o-matic

DESCRIPTION="Lightweight, free, cross-platform sound library"
HOMEPAGE="http://audiere.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="cdaudio debug dumb flac speex vorbis wxwidgets"

RDEPEND="cdaudio? ( media-libs/libcdaudio )
	dumb? ( media-libs/dumb )
	flac? ( media-libs/flac )
	speex? ( media-libs/speex )
	vorbis? ( media-libs/libvorbis )
	wxwidgets? ( >=x11-libs/wxGTK-2.6 )"
DEPEND="${RDEPEND}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/${P}-configure.in.patch" # speex detect and deps issues
	epatch "${FILESDIR}/${P}-speex-path.patch" # fix speex include path
	epatch "${FILESDIR}/${P}-Makefile.am.patch" # Needed for autoreconf
	epatch "${FILESDIR}/${P}-wx-fixes.patch" # SF.net bug #1688993
	epatch "${FILESDIR}/${P}-gcc-4.4-fixes.patch" # utility.cpp:67 error debianbug #560491
	eautoreconf || die "eautoreconf failed"
}

src_compile() {
	econf \
		$(use_enable cdaudio) \
		$(use_enable debug) \
		$(use_enable dumb) \
		$(use_enable flac) \
		$(use_with speex) \
		$(use_with vorbis) \
		$(use_enable wxwidgets player) || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc doc/*.txt
}
