# Distributed under the terms of the GNU General Public License v2

EAPI=4

inherit eutils games cmake-utils

DESCRIPTION="Doomseeker is a cross-platform server browser for Doom."
HOMEPAGE="http://doomseeker.drdteam.org/"
SRC_URI="http://doomseeker.drdteam.org/files/${P}_src.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="fake-plugins legacy-plugins"

DEPEND="app-arch/bzip2
	dev-qt/qtcore:4
	dev-qt/qtgui:4
	sys-libs/zlib"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${P}_src"

src_configure() {
	mycmakeargs+=(
		$(cmake-utils_use_build fake-plugins FAKE_PLUGINS)
		$(cmake-utils_use_build legacy-plugins LEGACY_PLUGINS)
	)

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	prepgamesdirs
}
