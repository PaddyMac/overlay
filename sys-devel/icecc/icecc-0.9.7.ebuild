# Copyright 2012 Funtoo Technologies
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit autotools eutils

DESCRIPTION="A distributed compilation system created by SUSE and based on distcc"
HOMEPAGE="http://en.opensuse.org/Icecream"
SRC_URI="ftp://ftp.suse.com/pub/projects/icecream/${P}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND="!sys-devel/distcc"
RDEPEND="${DEPEND}"
#S="${WORKDIR}/${P}"

src_configure() {
	econf \
		--enable-shared \
		$(use_enable static-libs static) \
		--bindir=/usr/share/icecc/bin
}

pkg_postinst() {

        elog
        elog "Tips on using icecc can be found at http://en.opensuse.org/Icecream"
	elog
	elog "Ensure that icecc's bin directory is first in your path, or at least earlier in the path that gcc."
	elog "You can accomplish this by adding this line to \~/.bashrc"
	elog "export PATH=/usr/share/icecc/bin\:\${PATH}"
	elog
	elog "To use icecream with Portage, use a command such as:"
	elog "PREROOTPATH=\"/usr/share/icecc/bin\" emerge foo"
	elog
}
