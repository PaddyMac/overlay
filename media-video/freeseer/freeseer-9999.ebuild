# Copyright 2012 Funtoo Technologies
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4-python
PYTHON_DEPEND="<<2:2.6>>"
inherit eutils distutils git-2

DESCRIPTION="Freeseer captures video from a choice of sources along with audio and mixes them together to produce a video."
HOMEPAGE="https://github.com/Freeseer/freeseer/wiki"
SRC_URI=""
EGIT_REPO_URI="https://github.com/Freeseer/freeseer.git"

EGIT_BRANCH="experimental"
EGIT_COMMIT="experimental"
EGIT_PROJECT="freeseer"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc +plugins"

DEPEND="sys-devel/make
	dev-db/sqlite:3
	dev-lang/python[sqlite]
	dev-python/PyQt4[sql]
	dev-python/gst-python
	dev-python/feedparser
	dev-python/passlib
	dev-python/python-xlib
	dev-python/setuptools
	dev-python/yapsy
	media-plugins/gst-plugins-v4l2
	media-plugins/gst-plugins-ximagesrc
	x11-libs/qt-sql[sqlite]"
RDEPEND="${DEPEND}
	doc? ( ~media-video/freeseer-docs-${PV} )
	plugins? ( ~media-video/freeseer-plugins-linux-${PV} )"

src_install() {
	distutils_src_install
	newicon src/freeseer/frontend/qtcommon/images/freeseer_logo.png freeseer.png
	make_desktop_entry ${PN}-config "Freeseer Configuration" ${PN}
	make_desktop_entry ${PN}-record Freeseer ${PN}
	make_desktop_entry ${PN}-reporteditor "Freeseer Report Editor" ${PN}
	make_desktop_entry ${PN}-talkeditor "Freeseer Talk Editor" ${PN}
}

DOCS="PACKAGE.txt README.md release_notes.txt docs/"
