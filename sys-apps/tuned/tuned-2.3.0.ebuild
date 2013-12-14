# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit python-single-r1 systemd

DESCRIPTION="Daemon for monitoring and adaptive tuning of system devices."
HOMEPAGE="https://fedorahosted.org/tuned/"
SRC_URI="https://fedorahosted.org/releases/t/u/tuned/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	dev-python/configobj
	dev-python/decorator"

src_prepare() {
	sed -i -e "/^UNITDIR = /s:\$(shell rpm --eval '%{_unitdir}'):$(systemd_get_unitdir):" Makefile
}

src_install() {
	default
	doinitd "${FILESDIR}"/tuned
}
