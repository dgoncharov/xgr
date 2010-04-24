# Copyright 2009 Dmitry Goncharov 
# Distributed under the terms of the BSD license
# $Header: $

inherit eutils

EAPI="1"

DESCRIPTION="A thread-safe and portable c++ library which makes easy having lots of timers in an application"
HOMEPAGE="http://timerpool.sourceforge.net"
SRC_URI="mirror://sourceforge/timerpool/${P}.tar.gz"
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
    econf || die "econf failed"
    emake || die "make failed"
}

src_install() {
    cd libtimerpool
	emake DESTDIR="${D}" install || die "emake install failed"
}

