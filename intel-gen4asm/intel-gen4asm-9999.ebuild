# Distributed under the terms of the GNU General Public License v2

EAPI=4

inherit autotools git-2

DESCRIPTION="A program to compile an assembly language for the Intel 965 Express Chipset."
HOMEPAGE="http://cgit.freedesktop.org/xorg/app/intel-gen4asm"
EGIT_REPO_URI="git://anongit.freedesktop.org/xorg/app/intel-gen4asm
	ssh://git.freedesktop.org/git/xorg/app/intel-gen4asm
	http://anongit.freedesktop.org/git/xorg/app/intel-gen4asm.git"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_prepare() {
	eautoreconf
}
