# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

inherit cmake-utils googlecode

ESVN_PATCHES="${P}-as-needed.patch"

DESCRIPTION="a modern terminal emulator for Linux"
SRC_URI="${HOMEPAGE}/files/QQWry.Dat.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	dev-libs/openssl
	media-libs/alsa-lib
	x11-libs/qt-core[ssl,qt3support]
	x11-libs/qt-gui"
DEPEND="${RDEPEND}
	app-arch/unzip"

src_unpack() {
	subversion_src_unpack
	unpack ${A}
}

src_install() {
	cmake-utils_src_install
	insinto /usr/share/FQTerm
	doins "${S}"/../QQWry.Dat || die
}

