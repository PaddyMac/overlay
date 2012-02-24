# Copyright 2012 Funtoo Technologies
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

MY_P="CELayoutEditor-${PV}"

DESCRIPTION="CEGUI Layout Editor"
HOMEPAGE="http://www.cegui.org.uk/"
SRC_URI="mirror://sourceforge/crayzedsgui/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=">=dev-games/cegui-0.7.0[opengl,silly]
	>=x11-libs/wxGTK-2.6.0"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"
