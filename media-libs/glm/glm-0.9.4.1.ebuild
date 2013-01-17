# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

DESCRIPTION="OpenGL Mathematics"
HOMEPAGE="http://glm.g-truc.net/"
SRC_URI="mirror://sourceforge/ogl-math/${P}/${P}.7z"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=""
DEPEND="app-arch/p7zip"

S=${WORKDIR}/glm

src_install() {
	rm core/dummy.cpp
	insinto /usr/include/${PN}
	doins -r *.hpp core gtc gtx virtrev
}
