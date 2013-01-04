# Distributed under the terms of the GNU General Public License v2

EAPI=4-python
PYTHON_DEPEND="<<2>>"

inherit distutils

DESCRIPTION="BigBrotherBot (B3) is a cross-platform, cross-game game administration bot."
HOMEPAGE="http://www.bigbrotherbot.net/ http://sourceforge.net/projects/bigbrotherbot/"
SRC_URI="mirror://sourceforge/bigbrotherbot/B3%20v1.8.2/${P}.zip"

LICENSE=""
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="dev-lang/python
	dev-python/mysql-python
	virtual/mysql"
RDEPEND="${DEPEND}"

