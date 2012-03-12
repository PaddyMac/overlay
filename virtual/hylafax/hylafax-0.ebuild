# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/virtual/ffmpeg/ffmpeg-0.9.ebuild,v 1.4 2012/01/31 00:19:36 jdhore Exp $

EAPI=4

DESCRIPTION="Virtual package for Hylafax implementation"
HOMEPAGE=""
SRC_URI=""

LICENSE=""
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc ~sparc ~x86"
IUSE="html jbig ldap mgetty pam"

RDEPEND="
        || (
                net-misc/hylafax[html=,jbig=,ldap=,mgetty=,pam=]
                net-misc/hylafax+[html=,jbig=,ldap=,mgetty=,pam=]
        )
"
DEPEND=""
