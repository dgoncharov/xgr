# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header $

inherit eutils flag-o-matic toolchain-funcs

DESCRIPTION="Kamailio - flexible and robust SIP (RFC3261) server"
HOMEPAGE="http://www.kamailio.org/"
MY_P="${P}_src"
SRC_URI="http://kamailio.org/pub/kamailio/${PV}/src/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="debug ipv6 mysql postgres radius jabber ssl cpl unixodbc"

RDEPEND="
	mysql? ( >=dev-db/mysql-4.1.20 )
	radius? ( >=net-dialup/radiusclient-ng-0.5.0 )
	postgres? ( >=dev-db/postgresql-server-8.0.8 )
	jabber? ( dev-libs/expat )
	ssl? ( dev-libs/openssl )
	cpl? ( dev-libs/libxml2 )
	unixodbc? ( >=dev-db/unixODBC-2.2.12 )"

DEPEND="${RDEPEND}
	>=sys-devel/bison-1.35
	>=sys-devel/flex-2.5.4a"

pkg_setup() {
	enewgroup kamailio
	enewuser  kamailio -1 -1 /dev/null kamailio
}

src_unpack() {
	unpack "${MY_P}".tar.gz

	cd "${S}"
	epatch "${FILESDIR}/${P}-makefile.diff"
	use ipv6 || \
		sed -i -e "s/-DUSE_IPV6//g" Makefile.defs
}

src_compile() {
	local compile_options
	local mod_inc="pv siputils kex"

	append-flags -fPIC #TODO: needed?
	# optimization can result in strange debuging symbols so omit it in case
	if use debug; then
		compile_options="${compile_options} mode=debug"
	else
		compile_options="${compile_options} CFLAGS=${CFLAGS}"
	fi

	if use ssl; then
		compile_options="TLS=1 ${compile_options}"
		mod_inc="${mod_inc} tls"
	fi

	local group_inc="standard"

	use mysql && \
		group_inc="${group_inc} mysql"

	use postgres && \
		group_inc="${group_inc} postgres"

	use radius && \
		group_inc="${group_inc} auth_radius misc_radius peering"

	use jabber && \
		group_inc="${group_inc} jabber"

	use cpl && \
		group_inc="${group_inc} cpl-c"

	use unixodbc && \
		group_inc="${group_inc} unixodbc"

	emake -j1 all \
		CC_EXTRA_OPTS="${CFLAGS}" \
		cfg-prefix=/ \
		cfg-target=/etc/kamailio/ \
		group_include="${group_inc}" \
		include_modules="${mod_inc}" || die "emake all failed"
}

src_install () {
	emake -j1 install \
		prefix="${D}"/usr \
		bin-prefix="${D}"/usr/sbin \
		bin-dir="" \
		cfg-prefix="${D}"/etc \
		cfg-dir=kamailio/ \
		cfg-target=/etc/kamailio/ \
		modules-prefix="${D}"/usr/$(get_libdir)/kamailio \
		modules-dir=modules \
		modules-target=/usr/$(get_libdir)/kamailio/modules/ \
		man-prefix="${D}"/usr/share/man \
		man-dir="" \
		doc-prefix="${D}"/usr/share/doc \
		doc-dir="${PF}" || die "emake install failed"

	newinitd "${FILESDIR}"/kamailio.init kamailio
	newconfd "${FILESDIR}"/kamailio.confd kamailio

	chown -R root:kamailio "${D}"/usr/etc/kamailio
	chmod 750 "${D}"/usr/etc/kamailio
	chmod 640 "${D}"/usr/etc/kamailio/*
}

pkg_postinst() {
	einfo "WARNING: If you upgraded from a previous Kamailio version"
	einfo "please read the README, NEWS and INSTALL files in the"
	einfo "documentation directory because the database and the"
	einfo "configuration file of old Kamailio versions are incompatible"
	einfo "with the current version."
}

pkg_prerm () {
	"${D}"/etc/init.d/kamailio stop >/dev/null
}
