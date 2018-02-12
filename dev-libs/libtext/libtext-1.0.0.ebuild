# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="6"

inherit eutils

DESCRIPTION="Shell style text parsing in c++."
HOMEPAGE="http://github.com/dgoncharov/libtext"
SRC_URI="https://github.com/dgoncharov/libtext/releases/download/1.0/libtext-1.0.tar.gz"
LICENSE="BSD"
KEYWORDS="~amd64 ~x86"
IUSE=""
SLOT="0"

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
}
