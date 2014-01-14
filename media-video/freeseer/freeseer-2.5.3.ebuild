# Copyright 2012 Funtoo Technologies
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4-python
PYTHON_DEPEND="<<2:2.6>>"
inherit distutils

DESCRIPTION="Freeseer captures video from a choice of sources along with audio and mixes them together to produce a video."
HOMEPAGE="https://github.com/Freeseer/freeseer/wiki"
SRC_URI="https://github.com/downloads/Freeseer/freeseer/freeseer-2.5.3.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="sys-devel/make
	dev-db/sqlite:3
	dev-lang/python[sqlite]
	dev-python/PyQt4
	dev-python/gst-python:0.10
	dev-python/feedparser
	dev-python/setuptools
	media-plugins/gst-plugins-v4l2:0.10
	media-plugins/gst-plugins-ximagesrc:0.10"
RDEPEND="${DEPEND}"
                                        
DOCS="PKG-INFO README.txt"
