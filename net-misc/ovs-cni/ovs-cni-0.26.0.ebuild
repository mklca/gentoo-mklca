# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit go-module

DESCRIPTION="Container networking infrastructure plugin for OpenVSwitch"
HOMEPAGE="https://github.com/k8snetworkplumbingwg/ovs-cni"

SRC_URI="https://github.com/k8snetworkplumbingwg/ovs-cni/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~ppc64"
IUSE="hardened"

RDEPEND=">=net-misc/openvswitch-2.16.1-r1"

S="${WORKDIR}/ovs-cni-${PV}"

src_compile() {
	mkdir "${WORKDIR}/bin"
	local cmdname=ovs
	einfo "Building ${cmdname} CNI plugin"
	CGO_LDFLAGS="$(usex hardened '-fno-PIC ' '')" go build -o "${WORKDIR}/bin/${cmdname}" "./cmd/plugin" || die
}

src_install() {
	exeinto /opt/cni/bin
	doexe "${WORKDIR}/bin/"*
	dodoc README.md
}
