# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
# Nonofficial ebuild by Ycarus, additions by Oliver Schneider and Matthias Kuhn. For new version look here : http://gentoo.zugaina.org/

IUSE=""

inherit eutils 
DESCRIPTION="A GTK+ 2.6 based XMMS2 client"
SRC_URI="http://wejp.k.vu/projects/xmms2/${P}.tar.gz"
HOMEPAGE="http://wejp.k.vu/projects/xmms2/"
LICENSE="GPL-2"
SLOT="0"
RESTRICT="nomirror"
KEYWORDS="~amd64 ~ppc ~sparc x86 ~hppa ~mips ~ppc64 ~alpha ~ia64"

RDEPEND=">=x11-libs/gtk+-2.6
	>=media-sound/xmms2-0.2.6"

src_compile() {
	sed -i -e "s/\/usr\/local\/bin/\/usr\/bin/g" Makefile
	emake gxmms2 || die "make failed"
}

src_install() {
	dodir /usr/bin
	exeinto /usr/bin
	doexe gxmms2
}
