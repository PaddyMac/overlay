# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit gnome2-utils cmake-utils

DESCRIPTION="A Japanese dictionary, kanji lookup tool, and learning assistant."
HOMEPAGE="http://www.tagaini.net/"
SRC_URI="https://github.com/downloads/Gnurou/${PN}/${P}.tar.gz"

LICENSE="CC-BY-SA-3.0 GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug test"

DEPEND=">=dev-qt/qtcore-4.5:4
	>=dev-qt/qtsql-4.5:4[sqlite]"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use test BUILD_TESTS)
		-DCPACK_BINARY=OFF
		-DCPACK_BINARY_TZ=OFF
		-DCPACK_SOURCE_TBZ2=OFF
		-DCPACK_SOURCE_TGZ=OFF
		-DCPACK_SOURCE_TZ=OFF
		$(cmake-utils_use debug DEBUG_DETAILED_VIEW)
		$(cmake-utils_use debug DEBUG_ENTRIES_CACHE)
		$(cmake-utils_use debug DEBUG_LISTS)
		$(cmake-utils_use debug DEBUG_PATHS)
		$(cmake-utils_use debug DEBUG_QUERIES)
		$(cmake-utils_use debug DEBUG_TRANSACTIONS)
		-DSHARED_SQLITE_LIBRARY=ON
	)

	cmake-utils_src_configure

#Configuration options not yet implemented in ebuild.
#DICT_LANG:STRING=fr;de;es;ru;it;pt;th;tr
#UI_LANG:STRING=ja;es;sv;cs;vi;fr;pl;nb;nl;ru;tr;it;de
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
