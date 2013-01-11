# Distributed under the terms of the GNU General Public License v2

EAPI=4

LANGS="de en es fr ja"

inherit versionator qt4-r2

MY_PN="Black_Chocobo"

DESCRIPTION="A Final Fantasy 7 save game editor."
HOMEPAGE="http://blackchocobo.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/$(get_version_component_range 1-2)/${PV}/${MY_PN}-${PV}_src.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="x11-libs/qt-core
	x11-libs/qt-gui
	x11-libs/qt-xmlpatterns"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${MY_PN}-${PV}_src

PATCHES=(
	"${FILESDIR}/${MY_PN}-${PV}-project.patch"
	"${FILESDIR}/${MY_PN}-${PV}-desktop.patch"
)
