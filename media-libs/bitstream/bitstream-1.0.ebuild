# Distributed under the terms of the GNU General Public License v2

EAPI=5

DESCRIPTION="A set of C headers allowing a simpler access to binary structures such as specified by MPEG, DVB, IETF, etc."
HOMEPAGE="http://www.videolan.org/developers/bitstream.html"
SRC_URI="http://download.videolan.org/pub/videolan/${PN}/${PV}/${P}.tar.bz2"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_install() {
	emake DESTDIR="${D}" PREFIX=/usr install
}
