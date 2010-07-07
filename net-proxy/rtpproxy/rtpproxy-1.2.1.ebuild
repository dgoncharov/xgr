# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

EAPI="1"

DESCRIPTION="Proxy server for RTP streams"
HOMEPAGE="http://www.rtpproxy.org"
SRC_URI="http://b2bua.org/chrome/site/${P}.tar.gz"
LICENSE="BSD"
KEYWORDS="~amd64 ~x86"
IUSE=""
SLOT="0"
RDEPEND=""
DEPEND=${RDEPEND}

src_compile() {
    econf || die "econf failed"
    emake || die "make failed"
}

src_install() {
    emake DESTDIR="${D}" install || die "emake install failed"
}

