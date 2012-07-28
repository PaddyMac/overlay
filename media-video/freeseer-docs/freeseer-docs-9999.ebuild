# Copyright 2012 Funtoo Technologies
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit git-2

MY_PF="freeseer-${PV}"

DESCRIPTION="Freeseer documentation."
HOMEPAGE="https://github.com/Freeseer/freeseer/wiki http://freeseer.github.com/docs/"
SRC_URI=""
EGIT_REPO_URI="https://github.com/Freeseer/freeseer-docs.git
		git://github.com/Freeseer/freeseer-docs.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="html dirhtml singlehtml pickle json htmlhelp qthelp devhelp epub latex latexpdf text +man changes linkcheck doctest"

DEPEND="latex? ( dev-python/sphinx[latex] )
	latexpdf? ( dev-python/sphinx[latex] )
	dev-python/sphinx
	~media-video/freeseer-${PV}"
RDEPEND="${DEPEND}"

src_compile() {
	use html && emake html
	use dirhtml && emake dirhtml
	use singlehtml && emake singlehtml
	use pickle && emake pickle
	use json && emake json
	use htmlhelp && emake htmlhelp
	use qthelp && emake qthelp
	use devhelp && emake devhelp
	use epub && emake epub
	use latex && emake latex
	use latexpdf && emake latexpdf
	use text && emake text
	use man && emake man
	use changes && emake changes
	use linkcheck && emake linkcheck
	use doctest && emake doctest
}

src_install() {
	if use html; then
		cp -r build/html /usr/share/doc/${MY_PF}/
	fi
	if use dirhtml; then   
                cp -r build/dirhtml /usr/share/doc/${MY_PF}/    
        fi
	if use singlehtml; then   
                cp -r build/singlehtml /usr/share/doc/${MY_PF}/    
        fi
	if use pickle; then   
                cp -r build/pickle /usr/share/doc/${MY_PF}/    
        fi
	if use json; then   
                cp -r build/json /usr/share/doc/${MY_PF}/    
        fi
	if use htmlhelp; then   
                cp -r build/htmlhelp /usr/share/doc/${MY_PF}/    
        fi
	if use qthelp; then   
                cp -r build/qthelp /usr/share/doc/${MY_PF}/    
        fi
	if use devhelp; then   
                cp -r build/devhelp /usr/share/doc/${MY_PF}/    
        fi
	if use epub; then   
                cp -r build/epub /usr/share/doc/${MY_PF}/    
        fi
	if use latex; then
		dodir /usr/share/doc/${MY_PF}/latex
                cp -r build/latex/*.tex /usr/share/doc/${MY_PF}/latex
        fi
	if use latexpdf; then
		dodir /usr/share/doc/${MY_PF}/latexpdf
                cp -r build/latex/*.pdf /usr/share/doc/${MY_PF}/latexpdf
        fi
	if use text; then   
                cp -r build/text /usr/share/doc/${MY_PF}/    
        fi
	if use man; then   
                doman build/man/*
        fi
	if use changes; then   
                cp -r build/changes /usr/share/doc/${MY_PF}/    
        fi
	if use linkcheck; then
                cp -r build/linkcheck /usr/share/doc/${MY_PF}/
        fi
	if use doctest; then
                cp -r build/doctest /usr/share/doc/${MY_PF}/
        fi
}
