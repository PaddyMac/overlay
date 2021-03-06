# Copyright 2012 Funtoo Technologies
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/em8300-libraries/em8300-libraries-0.18.0.ebuild,v 1.2 2010/03/01 16:47:57 ssuominen Exp $

EAPI=2
inherit autotools mercurial

MY_P=${P/-libraries}
MY_PN=${PN/-libraries}

DESCRIPTION="em8300 (RealMagic Hollywood+/Creative DXR3) video decoder card libraries"
HOMEPAGE="http://dxr3.sourceforge.net"
SRC_URI="mirror://gentoo/em8300-gtk-2.0.m4.tbz2"
EHG_REPO_URI="http://dxr3.hg.sourceforge.net/hgweb/dxr3/em8300/"
EHG_PROJECT="${MY_PN}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="gtk modules"

COMMON_DEPEND="gtk? ( x11-libs/gtk+:2 )"
RDEPEND="${COMMON_DEPEND}
	modules? ( ~media-video/em8300-modules-${PV} )"
DEPEND="${COMMON_DEPEND}
	virtual/pkgconfig"

S=${WORKDIR}/${MY_PN}

src_unpack() {
	mercurial_src_unpack
}

src_prepare() {
	# Separate kernel modules and fix Makefile bug.
	sed -i \
		-e 's:modules/\ ::g' \
		-e "s:test -z \"\$(firmwaredir)\":test -z\"\$(DESTDIR)(firmwaredir)\":g" \
		Makefile.am || die

	# Fix asneeded linking.
	sed -i \
		-e "s:AM_LDFLAGS:LDADD:" \
		{dhc,overlay}/Makefile.am || die

	AT_M4DIR=${WORKDIR} eautoreconf
}

src_configure()	{
	econf \
		$(use_enable gtk gtktest)
}

src_install() {
	dodir /lib/firmware
	emake DESTDIR="${D}" em8300incdir=/usr/include/linux install || die
	dodoc AUTHORS ChangeLog README
}

pkg_postinst() {
	elog "The em8300 libraries and modules have now been installed,"
	elog "you will probably want to add /usr/bin/em8300setup to your"
	elog "/etc/conf.d/local.start so that your em8300 card is "
	elog "properly initialized on boot."
	elog
	elog "If you still need a microcode other than the one included"
	elog "with the package, you can simply use em8300setup <microcode.ux>"
}
