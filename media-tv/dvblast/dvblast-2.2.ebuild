# Distributed under the terms of the GNU General Public License v2

EAPI=5

DESCRIPTION="A simple and powerful MPEG-2/TS demux and streaming application."
HOMEPAGE="http://www.videolan.org/projects/dvblast.html"
SRC_URI="http://downloads.videolan.org/pub/videolan/${PN}/${PV}/${P}.tar.bz2"

LICENSE="GPL-2 WTFPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="media-libs/bitstream"
RDEPEND="${DEPEND}"

src_prepare() {
	sed -i -e "/^CONF_BASE=\"/s:/usr/local/share/dvblast/dvbiscovery:/etc/dvblast/dvbiscovery:" extra/dvbiscovery/dvbiscovery.sh || die "sed dvbiscovery.sh failed"
}

src_install() {
	emake DESTDIR="${D}" PREFIX=/usr install
	dodoc AUTHORS NEWS README TODO

	dodoc -r extra/kernel-patches
	docinto dvbiscovery
	dodoc extra/dvbiscovery/README

	dobin extra/dvbiscovery/dvbiscovery.sh
	insinto /etc/dvblast/dvbiscovery
	doins extra/dvbiscovery/{dvbiscovery_atsc.conf,dvbiscovery_dvb-c.conf,dvbiscovery_dvb-s.conf,dvbiscovery_dvb-t.conf}
}

pkg_postinst() {
	einfo
	einfo "If you are interested in using the optional kernel patches, see the README file in /usr/share/doc/${PF}/kernel-patches."
	einfo
}
