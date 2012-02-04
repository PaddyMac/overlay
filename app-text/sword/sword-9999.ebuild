# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/sword/sword-1.6.2.ebuild,v 1.1 2011/06/11 17:52:00 beandog Exp $

EAPI="3"

inherit flag-o-matic subversion

ESVN_BOOTSTRAP="autogen.sh"
ESVN_REPO_URI="http://crosswire.org/svn/sword/trunk"

DESCRIPTION="Library for Bible reading software."
HOMEPAGE="http://www.crosswire.org/sword/"
SRC_URI=""
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~x86-fbsd ~ppc-macos"
IUSE="curl debug doc icu"

RDEPEND="sys-libs/zlib
	curl? ( net-misc/curl )
	icu? ( dev-libs/icu )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_unpack() {
        subversion_src_unpack
}

src_prepare() {
	subversion_bootstrap || die "${ESVN}: unknown problem occurred in subversion_bootstrap."
	cat > "${T}"/sword.conf <<- _EOF
		[Install]
		DataPath=${EPREFIX}/usr/share/sword/
	_EOF
}

src_configure() {
	strip-flags
	econf --with-zlib \
		--with-conf \
		$(use_with curl) \
		$(use_enable debug) \
		$(use_with icu) || die "configure failed"
}

src_install() {
	make DESTDIR="${D}" install || die "install failed"
	dodoc AUTHORS CODINGSTYLE ChangeLog README
	if use doc ;then
		rm -rf examples/.cvsignore
		rm -rf examples/cmdline/.cvsignore
		rm -rf examples/cmdline/.deps
		cp -R samples examples "${ED}/usr/share/doc/${PF}/"
	fi
	# global configuration file
	insinto /etc
	doins "${T}/sword.conf"
}

pkg_postinst() {
	echo
	elog "Check out http://www.crosswire.org/sword/modules/"
	elog "to download modules that you would like to use with SWORD."
	elog "Follow module installation instructions found on"
	elog "the web or in ${EPREFIX}/usr/share/doc/${PF}/"
	echo
}
