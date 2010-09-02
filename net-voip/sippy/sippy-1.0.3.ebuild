# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit distutils

DESCRIPTION="RFC3261-compliant SIP B2BUA"
HOMEPAGE="http://b2bua.org"
SRC_URI="http://b2bua.org/chrome/site/${P}.tar.gz"
IUSE=""
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
RDEPEND="dev-python/twisted"
DEPEND="${RDEPEND}"

src_install() {
	distutils_src_install
}
