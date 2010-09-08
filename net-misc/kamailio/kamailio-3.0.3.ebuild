# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils flag-o-matic toolchain-funcs

IUSE="ipv6 mysql radius postgres jabber ssl odbc"

DESCRIPTION="An Open SIP Express Router"
HOMEPAGE="http://www.kamailio.org/"
MY_P="${P}_src"
SRC_URI="http://www.${PN}.org/pub/${PN}/${PV}/src/${MY_P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"

RDEPEND=">=sys-devel/bison-1.35
	>=sys-devel/flex-2.5.4a
	ssl? ( dev-libs/openssl )
	mysql? ( >=dev-db/mysql-3.23.52 )
	radius? ( >=net-dialup/radiusclient-ng-0.5.0 )
	postgres? ( dev-db/libpq )
	jabber? ( dev-libs/expat )
	odbc? ( dev-db/unixODBC )"

DEPEND="${RDEPEND}"

src_unpack() {
	# unpack ser source
	unpack ${A}
	cd ${S}
	epatch "${FILESDIR}/${P}-makefile.diff"

	use ipv6 || \
		sed -i -e "s/-DUSE_IPV6//g" Makefile.defs

#	use ssl && \
#		sed -i -e "s:^#\(TLS=1\).*:\1:" Makefile
#
#	use mysql && KAMODULES="${KAMODULES} db_mysql mysql"
#
#	use radius && KAMODULES="${KAMODULES} auth_radius group_radius uri_radius avp_radius"
#
#	use jabber && KAMODULES="${KAMODULES} jabber xmpp pua_xmpp"
#
#	use postgres && KAMODULES="${KAMODULES} db_postgres postgres"
#
#	use odbc && KAMODULES="${KAMODULES} db_unixodbc unixodbc"
#
#	KAMODULES="${KAMODULES} presence presence_xml presence_mwi pua pua_bla pua_mi pua_usrloc"
#	for i in ${KAMODULES};
#	do
#		EXCMODULES="${EXCMODULES/$i/}"
#	done;
}

src_compile() {
	use amd64 && append-flags "-fPIC"

	compile_options=""
	mod_inc="pv siputils kex"

	append-flags -fPIC #TODO: needed?
	# optimization can result in strange debuging symbols so omit it in case
	if use debug; then
		compile_options="${compile_options} mode=debug"
	else
		compile_options="${compile_options} mode=release"
	fi

	if use ssl; then
		tls_hooks=1
		compile_options="TLS_HOOKS=1 ${compile_options}"
		mod_inc="${mod_inc} tls"
	else
		tls_hooks=0
	fi

	group_inc="standard"

	use mysql && \
		group_inc="${group_inc} mysql"

	use postgres && \
		group_inc="${group_inc} postgres"

	use radius && \
		group_inc="${group_inc} radius"

	use jabber && \
		mod_inc="${mod_inc} jabber"

	use cpl && \
		mod_inc="${mod_inc} cpl-c"

	use odbc && \
		mod_inc="${mod_inc} db_unixodbc unixodbc"


	emake -j1 \
		CC="$(tc-getCC)" \
		CPU_TYPE="$(get-flag march)" \
		TLS_HOOKS="${tls_hooks}" \
		prefix="/usr" \
		group_include="${group_inc}" \
		include_modules="${mod_inc}" \
		cfg-prefix="" \
		cfg-target="/etc/${PN}/" \
		cfg all || die
}

src_install() {
	emake -j1 \
		BASEDIR="${D}" \
		mode="release" \
		prefix="/usr" \
		group_include="${group_inc}" \
		include_modules="${mod_inc}" \
		cfg-prefix="${D}" \
		cfg-dir="/etc/${PN}/" \
		cfg-target="/etc/${PN}/" \
		doc-dir="share/doc/${P}/" \
		install || die

	newinitd ${FILESDIR}/${PN}.init ${PN}
	newconfd ${FILESDIR}/${PN}.confd ${PN}
}

pkg_preinst() {
	if [[ -z "$(egetent passwd ${PN})" ]]; then
		einfo "Adding ${PN} user and group"
		enewgroup ${PN}
		enewuser  ${PN} -1 -1 /dev/null ${PN}
	fi

	chown -R root:${PN}  ${D}/etc/${PN}
	chmod -R u=rwX,g=rX,o= ${D}/etc/${PN}
}

pkg_postinst() {
	ewarn "**************************** Upgrade Warning!******************************"
	ewarn "Please read:"
	ewarn
	ewarn "  http://${PN}.org/dokuwiki/doku.php/install:1.2.2-to-1.3.0"
	ewarn
	ewarn "For upgrade information"
	ewarn "**************************** Upgrade Warning!******************************"
}

