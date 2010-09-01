# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="g722 encoder and decoder"
HOMEPAGE="http://github.com/dgoncharov/g722tools"
SRC_URI="http://cloud.github.com/downloads/dgoncharov/g722tools/${P}.tar.gz"
LICENSE="BSD"
KEYWORDS="~amd64 ~x86"
IUSE=""
SLOT="0"

src_unpack() {
	unpack ${A}
}

src_compile() {
	econf || die "econf failed"
	emake || die "make failed"
}

src_install() {
	cd g722tools
	emake DESTDIR="${D}" install || die "emake install failed"
}
