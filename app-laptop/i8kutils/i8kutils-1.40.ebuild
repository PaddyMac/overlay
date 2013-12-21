# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit toolchain-funcs

DESCRIPTION="Dell Inspiron and Latitude utilities"
HOMEPAGE="http://packages.debian.org/sid/i8kutils"
SRC_URI="mirror://debian/pool/main/i/${PN}/${P/-/_}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="-* amd64 x86"
IUSE="examples tk"

DEPEND="tk? ( dev-lang/tk )"
RDEPEND="${DEPEND}"

DOCS=( README.i8kutils TODO )

src_prepare() {
	sed \
		-e '/^CC/d' \
		-e '/^CFLAGS/d' \
		-e 's: -g : $(LDFLAGS) :g' \
		-i Makefile || die

	tc-export CC
}

src_install() {
	dobin i8kbuttons i8kctl i8kfan
	doman i8kbuttons.1 i8kctl.1
	newconfd "${FILESDIR}"/i8kbuttons.conf i8kbuttons
	newinitd "${FILESDIR}"/i8kbuttons.init i8kbuttons

	if use tk; then
		dobin i8kmon
		doman i8kmon.1
		newconfd "${FILESDIR}"/i8kmon.conf i8kmon
		newinitd "${FILESDIR}"/i8kmon.init i8kmon
		insinto /etc
		doins i8kmon.conf
	fi

	use examples && dodoc -r examples
}
