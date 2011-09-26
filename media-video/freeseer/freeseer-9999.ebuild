# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
PYTHON_DEPEND="2:2.6:2.7"
inherit distutils git python

DESCRIPTION="Freeseer captures video from a choice of sources along with audio and mixes them together to produce a video."
HOMEPAGE="https://github.com/fosslc/freeseer/wiki/"
SRC_URI=""
EGIT_REPO_URI="https://github.com/fosslc/freeseer.git"

if use development; then
		BRANCH="development"
	elif use experimental; then
		BRANCH="experimental"
	elif use master; then
		BRANCH="master"
fi


EGIT_BRANCH="${BRANCH}"
EGIT_COMMIT="${BRANCH}"
EGIT_PROJECT="freeseer"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="development +experimental master"

DEPEND="sys-devel/make
	dev-db/sqlite:3
	dev-lang/python[sqlite]
	dev-python/PyQt4
	dev-python/gst-python
	dev-python/feedparser
	dev-python/setuptools
	dev-python/yapsy"
RDEPEND="${DEPEND}"
RESTRICT_PYTHON_ABIS="3.*"

src_compile() {
	distutils_src_compile
}

src_install() {
	distutils_src_install
}

DOCS="LICENSE PACKAGE.txt README.txt translate.txt"
