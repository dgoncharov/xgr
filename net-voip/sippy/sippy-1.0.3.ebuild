# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/python-irclib/python-irclib-0.4.8.ebuild,v 1.1 2008/12/07 01:01:09 patrick Exp $

inherit distutils

DESCRIPTION="RFC3261-compliant SIP B2BUA"
HOMEPAGE="http://b2bua.org"
SRC_URI="http://b2bua.org/chrome/site/sippy-1.0.3.tar.gz"
IUSE=""
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
RDEPEND="dev-python/twisted"
DEPEND=${RDEPEND}

src_install() {
	distutils_src_install
}

