# Copyright 2012 Funtoo Technologies
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4-python
PYTHON_DEPEND="<<2:2.7>>"
inherit eutils distutils

DESCRIPTION="Freeseer captures video from a choice of sources along with audio and mixes them together to produce a video."
HOMEPAGE="https://github.com/Freeseer/freeseer/wiki"
SRC_URI="https://github.com/Freeseer/${PN}/releases/download/v${PV}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

DEPEND="sys-devel/make
	dev-db/sqlite:3
	dev-lang/python[sqlite]
	dev-python/PyQt4[sql]
	dev-python/gst-python:0.10
	dev-python/feedparser
	dev-python/httplib2
	dev-python/oauth
	dev-python/passlib
	dev-python/python-xlib
	dev-python/setuptools
	dev-python/simplejson
	dev-python/yapsy
	dev-qt/qtsql:4[sqlite]
	media-plugins/gst-plugins-v4l2:0.10
	media-plugins/gst-plugins-ximagesrc:0.10"
RDEPEND="${DEPEND}
	doc? ( media-video/freeseer-docs )"

src_install() {
	distutils_src_install
	make_desktop_entry ${PN}-config "Freeseer Configuration" 48x48-${PN} "AudioVideo;Recorder;"
	make_desktop_entry ${PN}-record Freeseer 48x48-${PN} "AudioVideo;Recorder;"
	make_desktop_entry ${PN}-reporteditor "Freeseer Report Editor" 48x48-${PN} "AudioVideo;Recorder;"
	make_desktop_entry ${PN}-talkeditor "Freeseer Talk Editor" 48x48-${PN} "AudioVideo;Recorder;"
}
