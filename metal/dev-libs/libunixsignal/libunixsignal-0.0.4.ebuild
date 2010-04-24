# Copyright 2009 Dmitry Goncharov 
# Distributed under the terms of the BSD license
# $Header: $

inherit eutils

EAPI="1"

DESCRIPTION="A file descriptor associated with a unix signal"
HOMEPAGE="http://github.com/dgoncharov/libunixsignal"
SRC_URI="http://cloud.github.com/downloads/dgoncharov/libunixsignal/${P}.tar.gz"
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
    cd libunixsignal
	emake DESTDIR="${D}" install || die "emake install failed"
}

