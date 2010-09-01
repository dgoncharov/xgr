# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

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
