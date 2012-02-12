# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
inherit autotools eutils

DESCRIPTION="Small but powerful library implementing the client-server IRC protocol"
HOMEPAGE="http://www.ulduzsoft.com/libircclient/"
SRC_URI="mirror://sourceforge/libircclient/${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc ipv6 threads"

src_prepare() {
	epatch "${FILESDIR}"/${P}-build.patch
	eautoconf
}

src_configure() {
	econf \
		$(use_enable ipv6) \
		$(use_enable threads thread)
}

src_compile() {
	emake -C src
}

src_install() {
	insinto /usr/include/libircclient
	doins include/*.h
	dolib src/libircclient.a

	dodoc Changelog THANKS
	if use doc ; then
		doman doc/man/man3/*
		dohtml doc/html/*
	fi
}
