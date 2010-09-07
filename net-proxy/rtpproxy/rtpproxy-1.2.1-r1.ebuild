# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="Proxy server for RTP streams"
HOMEPAGE="http://www.rtpproxy.org"
SRC_URI="http://b2bua.org/chrome/site/${P}.tar.gz"
LICENSE="BSD"
KEYWORDS="~amd64 ~x86"
IUSE=""
SLOT="0"
RDEPEND=""
DEPEND="${RDEPEND}"

pkg_setup() {
	enewgroup rtpproxy
	enewuser  rtpproxy -1 -1 /dev/null rtpproxy
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"

	newinitd "${FILESDIR}"/rtpproxy.init rtpproxy
	newconfd "${FILESDIR}"/rtpproxy.confd rtpproxy
}
