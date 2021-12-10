# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit go-module linux-info systemd

DESCRIPTION="Standard networking plugins for container networking"
HOMEPAGE="https://github.com/containernetworking/plugins"
SRC_URI="https://github.com/containernetworking/plugins/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 arm64 ~ppc64"
IUSE="examples hardened systemd"

CONFIG_CHECK="~BRIDGE_VLAN_FILTERING"
S="${WORKDIR}/plugins-${PV}"

src_compile() {
	mkdir "${WORKDIR}/bin"
	local plugname
	local plugpath
	for plugname in bandwidth firewall portmap sbr tuning vrf; do
		plugpath="./plugins/meta/${plugname}"
		CGO_LDFLAGS="$(usex hardened '-fno-PIC ' '')" "${GO:-go}" build -o "${WORKDIR}/bin/${cmdname}" "${plugpath}" || die
	done
	for plugname in bridge host-device ipvlan loopback macvlan ptp vlan; do
		plugpath="./plugins/main/${plugname}"
		CGO_LDFLAGS="$(usex hardened '-fno-PIC ' '')" "${GO:-go}" build -o "${WORKDIR}/bin/${cmdname}" "${plugpath}" || die
	done
	for plugname in dhcp host-local static; do
		plugpath="./plugins/ipam/${plugname}"
		CGO_LDFLAGS="$(usex hardened '-fno-PIC ' '')" "${GO:-go}" build -o "${WORKDIR}/bin/${cmdname}" "${plugpath}" || die
	done
	if use "examples"; then
		plugname=sample
		plugpath="./plugins/sample"
		CGO_LDFLAGS="$(usex hardened '-fno-PIC ' '')" "${GO:-go}" build -o "${WORKDIR}/bin/${cmdname}" "${plugpath}" || die
	fi
}

src_install() {
	exeinto /opt/cni/bin
	doexe "${WORKDIR}/bin/"*
	dodoc README.md

	if use "systemd"; then
		systemd_newunit "./plugins/ipam/dhcp/systemd/cni-dhcp.service" "cni-dhcp.service"
		systemd_newunit "./plugins/ipam/dhcp/systemd/cni-dhcp.socket" "cni-dhcp.socket"
	else
		newinitd "${FILESDIR}"/cni-dhcp.initd cni-dhcp
	fi
}
