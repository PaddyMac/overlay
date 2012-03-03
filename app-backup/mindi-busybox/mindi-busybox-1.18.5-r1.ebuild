# Copyright 2012 Funtoo Technologies
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils flag-o-matic

DESCRIPTION="Busybox version suited for Mindi"
HOMEPAGE="http://www.mondorescue.org"
SRC_URI="ftp://ftp.mondorescue.org//src/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ia64 ~amd64 -*"
DEPEND="virtual/libc"
RDEPEND=">=app-arch/bzip2-0.9
		sys-devel/binutils"

src_unpack() {
	unpack ${A} || die "Failed to unpack ${A}"
	cd ${P}
	make oldconfig > /dev/null
}

src_compile() {
	# work around broken ass powerpc compilers
	emake EXTRA_CFLAGS="${CFLAGS}" busybox || die "build failed"
}

src_install() {
	# bundle up the symlink files for use later
	emake CONFIG_PREFIX="${D}/usr/lib/mindi/rootfs" install || die
}
