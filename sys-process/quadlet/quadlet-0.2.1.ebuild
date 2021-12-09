# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson

DESCRIPTION="Quadlet is the optimal way to run podman system containers under systemd"
HOMEPAGE="https://github.com/containers/quadlet"
SRC_URI="https://github.com/containers/${PN}/archive/${PV}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64"
