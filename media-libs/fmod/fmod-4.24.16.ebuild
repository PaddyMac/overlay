# Distributed under the terms of the GNU General Public License v2

inherit versionator

MY_P=fmodapi$(delete_all_version_separators)linux

DESCRIPTION="music and sound effects library, and a sound processing system"
HOMEPAGE="http://www.fmod.org"
SRC_URI="amd64? ( http://www.fmod.org/download/fmodex/api/Linux/${MY_P}64.tar.gz )
	x86? ( http://www.fmod.org/download/fmodex/api/Linux/${MY_P}.tar.gz )"

LICENSE="BSD BSD-2 fmod"
SLOT="4.24.16"
KEYWORDS="~amd64 ~x86"
IUSE="designer examples tools"

RESTRICT="strip test"

QA_FLAGS_IGNORED="opt/fmodex/tools/fsbanklib/.*"
QA_PREBUILT="opt/fmodex/fmoddesignerapi/api/lib/*
	opt/fmodex/api/lib/*"
QA_TEXTRELS="opt/fmodex/fmoddesignerapi/api/lib/*
	opt/fmodex/api/lib/*"

if use amd64; then
	S=${WORKDIR}/${MY_P}64
elif use x86; then
	S=${WORKDIR}/${MY_P}
fi

src_compile() {
	if use examples; then
		if use amd64; then
			emake -j1 fmod_examples CPU=x64
		elif use x86; then
			emake -j1 fmod_examples CPU=x86
		fi
	fi
}

src_install() {
	dodir /opt/fmodex-${PV}

	cp -dpR api "${D}"/opt/fmodex-${PV} || die

	if use designer; then
		if use examples; then
			cp -dpR fmoddesignerapi "${D}"/opt/fmodex-${PV} || die
		elif use !examples; then
			rm -r fmoddesignerapi/examples
			cp -dpR fmoddesignerapi "${D}"/opt/fmodex-${PV} || die
		fi
	fi

	if use examples; then
		cp -dpR examples "${D}"/opt/fmodex || die
	fi

	if use tools; then
		cp -dpR tools "${D}"/opt/fmodex || die
	fi

	insinto /usr/share/doc/${PF}/pdf
	doins documentation/*.pdf
	insinto /usr/share/doc/${PF}/chm
	doins documentation/*.chm
	dodoc {documentation/*.txt,fmoddesignerapi/*.TXT}
	rm -rf "${D}"/opt/fmodex/{documentation,fmoddesignerapi/*.TXT}
}
