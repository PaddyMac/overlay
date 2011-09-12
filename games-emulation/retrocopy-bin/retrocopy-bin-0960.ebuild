# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
EAPI=4

inherit eutils

MY_PN="retrocopy"

DESCRIPTION="RetroCopy is a multiple home and arcade system emulator and media player"

HOMEPAGE="http://www.retrocopy.com/"

X86_URI="http://www.retrocopy.com/downloads/${MY_PN}_linux32_${PV}.tar.lzma"
SRC_URI="x86? ( ${X86_URI} )
        amd64? (
		http://www.retrocopy.com/downloads/${MY_PN}_linux64_${PV}.tar.lzma
		multilib? ( ${X86_URI} )
	)"

# License of the package.  This must match the name of file(s) in
# /usr/portage/licenses/.  For complex license combination see the developer
# docs on gentoo.org for details.
LICENSE=""

SLOT="0"

KEYWORDS="~amd64 ~x86"

IUSE=""

RESTRICT="mirror strip"

DEPEND=""

RDEPEND="${DEPEND}"

S="${WORKDIR}"

src_install() {
	insinto /opt/retrocopy
	doins -r *
        
	if multilib; then
		fperms 755 /opt/retrocopy/retrocopy
		dosym /opt/retrocopy/retrocopy /opt/bin/retrocopy
        elif amd64; then
        	fperms 755 /opt/retrocopy/retrocopy64
        	dosym /opt/retrocopy/retrocopy64 /opt/bin/retrocopy
	elif x86; then
		fperms 755 /opt/retrocopy/retrocopy
		dosym /opt/retrocopy/retrocopy /opt/bin/retrocopy
	fi
}
