# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="A small command line utility which moves files and directories by regular expressions"
HOMEPAGE="http://remv.sf.net"
SRC_URI="mirror://sourceforge/remv/${P}.tar.gz"
LICENSE="BSD"
KEYWORDS="~amd64 ~x86"
IUSE=""
SLOT="0"
RDEPEND=">=dev-libs/boost-1.37"
DEPEND=${RDEPEND}

# src_install() has to be defined.
# For an unknown reason the default src_install() installs the package w/o
# creating proper CONTENTS file in /var/db.
src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
}
