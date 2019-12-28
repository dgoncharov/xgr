# Copyright 2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=3
inherit eutils

DESCRIPTION='Mount Android phones on Linux with adb. No root required.'
HOMEPAGE='https://github.com/dgoncharov/adbfs-rootless'
# When a tag is called adbfs-rootless-1.0 github rolls a tarball with
# all contents inside directory adbfs-rootless-adbfs-rootless-1.0/.
SRC_URI="https://github.com/dgoncharov/adbfs-rootless/archive/${PV}.tar.gz -> $P.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="sys-fs/fuse dev-util/android-tools"
RDEPEND="${DEPEND}"

src_install()
{
    emake DESTDIR="${D}" install || die "emake install failed"
}
