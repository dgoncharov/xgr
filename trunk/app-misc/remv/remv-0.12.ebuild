# Copyright 2009 Dmitry Goncharov 
# Distributed under the terms of the BSD license
# $Header: $

inherit eutils

EAPI="1"

DESCRIPTION="A small command line utility which moves files and directories by regular expressions"
HOMEPAGE="http://remv.sourceforge.net"
SRC_URI="mirror://sourceforge/remv/${P}.tar.gz"
LICENSE="BSD"
KEYWORDS="~amd64 ~x86"
IUSE=""
SLOT="0"
RDEPEND=">=dev-libs/boost-1.37"
DEPEND=${RDEPEND}

src_unpack() {
    unpack ${A}
}

src_compile() {
    cd ${WORKDIR}/remv.svn
    econf || die "econf failed"
    emake || die "make failed"
}

src_install() {
    cd remv
	emake DESTDIR="${D}" install || die "emake install failed"
}

