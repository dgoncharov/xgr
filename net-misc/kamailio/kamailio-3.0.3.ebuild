# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils flag-o-matic toolchain-funcs

DESCRIPTION="Kamailio (former OpenSER) is an Open Source SIP Server"
HOMEPAGE="http://www.kamailio.org/"
MY_P="${P}_src"
SRC_URI="http://www.${PN}.org/pub/${PN}/${PV}/src/${MY_P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"

IUSE="debug ipv6
group_standard group_mysql group_radius group_postgres group_presence
acc acc_radius alias_db auth auth_db auth_diameter auth_identity auth_radius
avpops bdb benchmark call_control carrierroute cfg_db cfg_rpc cfgutils cpl
cpl-c ctl CVS db_berkeley db_flatstore dbg db_mysql db_oracle db_postgres
dbtext db_text db_unixodbc dialog dialplan dispatcher diversion domain
domainpolicy drouting enum exec group h350 htable imc iptrtpproxy jabber kex
lcr ldap mangler maxfwd mediaproxy memcached mi_datagram mi_fifo mi_rpc
misc_radius mi_xmlrpc msilo nathelper nat_traversal oracle osp pa path pdb
pdt peering perl perlvdb permissions pike presence presence_b2b
presence_dialoginfo presence_mwi presence_xml print_lib pua pua_bla
pua_dialoginfo pua_mi pua_usrloc pua_xmpp purple pv qos ratelimit regex
registrar rls rr rtimer sanity seas siptrace siputils sl sms snmpstats
speeddial sqlops sst statistics textops tls tm tmx topoh uac uac_redirect
unixsock uri_db userblacklist usrloc utils xcap xcap_client xlog xmlrpc xmpp"

# Some of these modules have external dependencies.
# If you need to use a modules for which this ebuild does not have a proper
# dependency, please, read http://www.kamailio.org/docs/modules/3.0.x/
# and add fix the ebuild.
# So far, i only tested group_standard, group_radius, tm, pv, sl, auth,
# auth_db, db_mysql, rr, maxfwd, usrloc, registrar, textops, nathelper,
# xlog, kex, siputils, tls.
# sercmd needs ncurses and readline.
RDEPEND="
	>=sys-libs/ncurses-5.7-r5
	>=sys-libs/readline-6.1_p2
	group_mysql? ( >=dev-db/mysql-5.1.50 )
	group_radius? ( >=net-dialup/radiusclient-ng-0.5.0 )
	group_postgres? ( dev-db/postgresql-base )
	jabber? ( dev-libs/expat )
	tls? (
		>=sys-libs/zlib-1.2.5-r2
		>=dev-libs/openssl-1.0.0a-r1
	)
	cpl? ( dev-libs/libxml2 )
	odbc? ( dev-db/unixODBC )
	db_mysql? (
		>=dev-db/mysql-5.1.50
		>=sys-libs/zlib-1.2.5-r2
		>=dev-libs/openssl-1.0.0a-r1
	)"

DEPEND="${RDEPEND}
	>=sys-devel/bison-1.35
	>=sys-devel/flex-2.5.4a"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/${P}-makefile.diff"

	use ipv6 || \
		sed -i -e "s/-DUSE_IPV6//g" Makefile.defs
}

src_compile() {
	local group_inc=""
	use group_standard && group_inc="${group_inc} standard"
	use group_mysql && group_inc="${group_inc} mysql"
	use group_radius && group_inc="${group_inc} radius"
	use group_postgres && group_inc="${group_inc} postgres"
	use group_presence && group_inc="${group_inc} presence"

	local mod_inc=""
	use acc && mod_inc="${mod_inc} acc"
	use acc_radius && mod_inc="${mod_inc} acc_radius"
	use alias_db && mod_inc="${mod_inc} alias_db"
	use auth_db && mod_inc="${mod_inc} auth_db"
	use auth_diameter && mod_inc="${mod_inc} auth_diameter"
	use auth_identity && mod_inc="${mod_inc} auth_identity"
	use auth && mod_inc="${mod_inc} auth"
	use auth_radius && mod_inc="${mod_inc} auth_radius"
	use avpops && mod_inc="${mod_inc} avpops"
	use bdb && mod_inc="${mod_inc} bdb"
	use benchmark && mod_inc="${mod_inc} benchmark"
	use call_control && mod_inc="${mod_inc} call_control"
	use carrierroute && mod_inc="${mod_inc} carrierroute"
	use cfg_db && mod_inc="${mod_inc} cfg_db"
	use cfg_rpc && mod_inc="${mod_inc} cfg_rpc"
	use cfgutils && mod_inc="${mod_inc} cfgutils"
	use cpl-c && mod_inc="${mod_inc} cpl-c"
	use cpl && mod_inc="${mod_inc} cpl"
	use ctl && mod_inc="${mod_inc} ctl"
	use CVS && mod_inc="${mod_inc} CVS"
	use db_berkeley && mod_inc="${mod_inc} db_berkeley"
	use db_flatstore && mod_inc="${mod_inc} db_flatstore"
	use dbg && mod_inc="${mod_inc} dbg"
	use db_mysql && mod_inc="${mod_inc} db_mysql"
	use db_oracle && mod_inc="${mod_inc} db_oracle"
	use db_postgres && mod_inc="${mod_inc} db_postgres"
	use db_text && mod_inc="${mod_inc} db_text"
	use dbtext && mod_inc="${mod_inc} dbtext"
	use db_unixodbc && mod_inc="${mod_inc} db_unixodbc"
	use dialog && mod_inc="${mod_inc} dialog"
	use dialplan && mod_inc="${mod_inc} dialplan"
	use dispatcher && mod_inc="${mod_inc} dispatcher"
	use diversion && mod_inc="${mod_inc} diversion"
	use domain && mod_inc="${mod_inc} domain"
	use domainpolicy && mod_inc="${mod_inc} domainpolicy"
	use drouting && mod_inc="${mod_inc} drouting"
	use enum && mod_inc="${mod_inc} enum"
	use exec && mod_inc="${mod_inc} exec"
	use group && mod_inc="${mod_inc} group"
	use h350 && mod_inc="${mod_inc} h350"
	use htable && mod_inc="${mod_inc} htable"
	use imc && mod_inc="${mod_inc} imc"
	use iptrtpproxy && mod_inc="${mod_inc} iptrtpproxy"
	use jabber && mod_inc="${mod_inc} jabber"
	use kex && mod_inc="${mod_inc} kex"
	use lcr && mod_inc="${mod_inc} lcr"
	use ldap && mod_inc="${mod_inc} ldap"
	use mangler && mod_inc="${mod_inc} mangler"
	use maxfwd && mod_inc="${mod_inc} maxfwd"
	use mediaproxy && mod_inc="${mod_inc} mediaproxy"
	use memcached && mod_inc="${mod_inc} memcached"
	use mi_datagram && mod_inc="${mod_inc} mi_datagram"
	use mi_fifo && mod_inc="${mod_inc} mi_fifo"
	use mi_rpc && mod_inc="${mod_inc} mi_rpc"
	use misc_radius && mod_inc="${mod_inc} misc_radius"
	use mi_xmlrpc && mod_inc="${mod_inc} mi_xmlrpc"
	use msilo && mod_inc="${mod_inc} msilo"
	use nathelper && mod_inc="${mod_inc} nathelper"
	use nat_traversal && mod_inc="${mod_inc} nat_traversal"
	use oracle && mod_inc="${mod_inc} oracle"
	use osp && mod_inc="${mod_inc} osp"
	use pa && mod_inc="${mod_inc} pa"
	use path && mod_inc="${mod_inc} path"
	use pdb && mod_inc="${mod_inc} pdb"
	use pdt && mod_inc="${mod_inc} pdt"
	use peering && mod_inc="${mod_inc} peering"
	use perl && mod_inc="${mod_inc} perl"
	use perlvdb && mod_inc="${mod_inc} perlvdb"
	use permissions && mod_inc="${mod_inc} permissions"
	use pike && mod_inc="${mod_inc} pike"
	use presence_b2b && mod_inc="${mod_inc} presence_b2b"
	use presence_dialoginfo && mod_inc="${mod_inc} presence_dialoginfo"
	use presence && mod_inc="${mod_inc} presence"
	use presence_mwi && mod_inc="${mod_inc} presence_mwi"
	use presence_xml && mod_inc="${mod_inc} presence_xml"
	use print_lib && mod_inc="${mod_inc} print_lib"
	use pua_bla && mod_inc="${mod_inc} pua_bla"
	use pua_dialoginfo && mod_inc="${mod_inc} pua_dialoginfo"
	use pua_mi && mod_inc="${mod_inc} pua_mi"
	use pua && mod_inc="${mod_inc} pua"
	use pua_usrloc && mod_inc="${mod_inc} pua_usrloc"
	use pua_xmpp && mod_inc="${mod_inc} pua_xmpp"
	use purple && mod_inc="${mod_inc} purple"
	use pv && mod_inc="${mod_inc} pv"
	use qos && mod_inc="${mod_inc} qos"
	use ratelimit && mod_inc="${mod_inc} ratelimit"
	use regex && mod_inc="${mod_inc} regex"
	use registrar && mod_inc="${mod_inc} registrar"
	use rls && mod_inc="${mod_inc} rls"
	use rr && mod_inc="${mod_inc} rr"
	use rtimer && mod_inc="${mod_inc} rtimer"
	use sanity && mod_inc="${mod_inc} sanity"
	use seas && mod_inc="${mod_inc} seas"
	use siptrace && mod_inc="${mod_inc} siptrace"
	use siputils && mod_inc="${mod_inc} siputils"
	use sl && mod_inc="${mod_inc} sl"
	use sms && mod_inc="${mod_inc} sms"
	use snmpstats && mod_inc="${mod_inc} snmpstats"
	use speeddial && mod_inc="${mod_inc} speeddial"
	use sqlops && mod_inc="${mod_inc} sqlops"
	use sst && mod_inc="${mod_inc} sst"
	use statistics && mod_inc="${mod_inc} statistics"
	use textops && mod_inc="${mod_inc} textops"
	use tm && mod_inc="${mod_inc} tm"
	use tmx && mod_inc="${mod_inc} tmx"
	use topoh && mod_inc="${mod_inc} topoh"
	use uac && mod_inc="${mod_inc} uac"
	use uac_redirect && mod_inc="${mod_inc} uac_redirect"
	use unixsock && mod_inc="${mod_inc} unixsock"
	use uri_db && mod_inc="${mod_inc} uri_db"
	use userblacklist && mod_inc="${mod_inc} userblacklist"
	use usrloc && mod_inc="${mod_inc} usrloc"
	use utils && mod_inc="${mod_inc} utils"
	use xcap_client && mod_inc="${mod_inc} xcap_client"
	use xcap && mod_inc="${mod_inc} xcap"
	use xlog && mod_inc="${mod_inc} xlog"
	use xmlrpc && mod_inc="${mod_inc} xmlrpc"
	use xmpp && mod_inc="${mod_inc} xmpp"

	if use tls; then
		tls_hooks=1
		mod_inc="${mod_inc} tls"
	else
		tls_hooks=0
	fi

	if use debug; then
		mode=debug
	else
		mode=release
	fi

	emake \
		CC="$(tc-getCC)" \
		CPU_TYPE="$(get-flag march)" \
		mode="${mode}" \
		TLS_HOOKS="${tls_hooks}" \
		group_include="${group_inc}" \
		include_modules="${mod_inc}" \
		cfg_prefix="" \
		cfg_target="/etc/${PN}/" \
		prefix="/usr" \
		all || die "emake all failed"
}

src_install() {
	emake \
		BASEDIR="${D}" \
		prefix="/usr" \
		cfg_prefix="${D}" \
		install || die "emake install failed"

	newinitd "${FILESDIR}/${PN}".init "${PN}"
	newconfd "${FILESDIR}/${PN}".confd "${PN}"
}

pkg_preinst() {
	if [[ -z "$(egetent passwd ${PN})" ]]; then
		einfo "Adding ${PN} user and group"
		enewgroup "${PN}"
		enewuser  "${PN}" -1 -1 /dev/null "${PN}"
	fi

	chown -R root:"${PN}"  "${D}/etc/${PN}"
	chmod -R u=rwX,g=rX,o= "${D}/etc/${PN}"
}
pkg_prerm () {
	/etc/init.d/"${PN}" stop >/dev/null
}
