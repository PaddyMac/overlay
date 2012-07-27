# Copyright 2012 Funtoo Technologies
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
inherit git-2

DESCRIPTION="Additional Freeseer plugins for Linux."
HOMEPAGE="https://github.com/Freeseer/freeseer/wiki"
SRC_URI=""
EGIT_REPO_URI="https://github.com/Freeseer/freeseer-plugins-linux.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="~media-video/freeseer-9999"
RDEPEND="${DEPEND}"

src_install() {
	dodir /usr/lib/python2.7/site-packages/freeseer/plugins/
	cp -R "${S}"/* "${D}"/usr/lib/python2.7/site-packages/freeseer/plugins/ || die "Install failed!"
}
