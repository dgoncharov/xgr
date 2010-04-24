# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-fs/fuse/fuse-2.7.3.ebuild,v 1.2 2008/09/08 05:07:34 jer Exp $

inherit eutils

EAPI="1"

MY_P=${P/-/.}
DESCRIPTION="Sipp is a performance testing tool for the SIP protocol."
HOMEPAGE="http://sipp.sourceforge.net"
SRC_URI="mirror://sourceforge/sipp/${MY_P}.src.tar.gz"
LICENSE="GPL"
KEYWORDS="~amd64 ~x86"
IUSE="openssl pcap"
SLOT="0"
RDEPEND="
    openssl? ( dev-libs/openssl ) 
    pcap? ( net-libs/libpcap )
    sys-libs/ncurses
    "
DEPEND=${RDEPEND}

src_unpack() {
    unpack ${A}
    cd "${S}"
    epatch ${FILESDIR}/gcc-4.3.2-sipp.patch
}

src_compile() {
    cd ${WORKDIR}/sipp.svn
    if use openssl; then
        if use pcap; then
	    emake pcapplay_ossl || die "make failed"
	else
	    emake ossl || die "make failed"
	fi
    else
        if use pcap; then
	    emake pcapplay || die "make failed"
	else
	    emake all || die "make failed"
	fi
    fi
}

src_install() {
    if [ -f ${WORKDIR}/sipp.svn/sipp ]; then
        dobin ${WORKDIR}/sipp.svn/sipp
    fi
}
