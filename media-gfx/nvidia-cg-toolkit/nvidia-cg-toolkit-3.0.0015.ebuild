# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/nvidia-cg-toolkit/nvidia-cg-toolkit-2.1.0017.ebuild,v 1.1 2009/03/01 21:31:51 vapier Exp $

EAPI=2
inherit versionator

MY_PV="$(get_version_component_range 1-2)"
MY_DATE="November2010"
DESCRIPTION="NVIDIA's C graphics compiler toolkit"
HOMEPAGE="http://developer.nvidia.com/object/cg_toolkit.html"
X86_URI="http://developer.download.nvidia.com/cg/Cg_${MY_PV}/${PV}/Cg-${MY_PV}_${MY_DATE}_x86.tgz"
SRC_URI="x86? ( ${X86_URI} )
	amd64? (
		http://developer.download.nvidia.com/cg/Cg_2.0/${PV}/Cg-${MY_PV}_${MY_DATE}_x86_64.tgz
		multilib? ( ${X86_URI} )
	)"

LICENSE="NVIDIA"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="multilib symlink_binaries"
RESTRICT="strip"

RDEPEND="media-libs/freeglut
	x86? ( virtual/libstdc++:3.3 )
	multilib? ( amd64? ( app-emulation/emul-linux-x86-xlibs ) )"

S=${WORKDIR}

DEST=/opt/${PN}

src_unpack() {
	if use multilib && use amd64; then
		for i in $A; do
			if [[ "$i" =~ .*x86_64.* ]]; then
				mkdir 64bit
				cd 64bit
				unpack "$i"
				cd ..
			else
				mkdir 32bit
				cd 32bit
				unpack "$i"
				cd ..
			fi
		done
	else
		default
	fi
}

src_install() {
	into ${DEST}
	if use multilib && use amd64; then
		cd 64bit
	fi

	dobin usr/bin/cgc || die
	dobin usr/bin/cgfxcat || die
	dobin usr/bin/cginfo || die
	dodir /opt/bin || die
	dosym ${DEST}/bin/cgc /opt/bin/cgc || die
	dosym ${DEST}/bin/cgfxcat /opt/bin/cgfxcat || die
	dosym ${DEST}/bin/cginfo /opt/bin/cginfo || die

	if use symlink_binaries; then
		dosym ${DEST}/bin/cgc /usr/bin/cgc || die
		dosym ${DEST}/bin/cgfxcat /usr/bin/cgfxcat || die
		dosym ${DEST}/bin/cginfo /usr/bin/cginfo || die
	fi

	if use x86; then
		dolib usr/lib/* || die
	elif use amd64; then
		dolib usr/lib64/*
		if use multilib && use amd64; then
			cd ../32bit
			ABI="x86" dolib usr/lib/*
			cd ../64bit
		fi
	fi

	exeinto ${DEST}/lib
	if use x86 ; then
		doexe usr/lib/* || die
		if use symlink_binaries; then
                        dosym ${DEST}/lib/libCg.so /usr/lib/libCg.so || die
                        dosym ${DEST}/lib/libCgGL.so /usr/lib/libCgGL.so || die
                fi
	elif use amd64 ; then
		doexe usr/lib64/* || die
		if use symlink_binaries; then
			dosym ${DEST}/lib64/libCg.so /usr/lib64/libCg.so || die
			dosym ${DEST}/lib64/libCgGL.so /usr/lib64/libCgGL.so || die
		fi
	fi

	doenvd "${FILESDIR}"/80cgc-opt

	insinto ${DEST}/include/Cg
	doins usr/include/Cg/*
	if use symlink_binaries; then
		dodir /usr/include/Cg || die
		dosym ${DEST}/include/Cg/cg.h /usr/include/Cg/cg.h || die
		dosym ${DEST}/include/Cg/cgGL.h /usr/include/Cg/cgGL.h || die
	fi

	insinto ${DEST}/man/man3
	doins usr/share/man/man3/*

	insinto ${DEST}
	doins -r usr/local/Cg/{docs,examples,README}
}

pkg_postinst() {
	einfo "Starting with ${CATEGORY}/${PN}-2.1.0016, ${PN} is installed in"
	einfo "${DEST}.  Packages might have to add something like:"
	einfo "  append-cppflags -I${DEST}/include"
}
