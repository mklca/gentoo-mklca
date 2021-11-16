# Copyright 2021 Mikaela Allan
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson

DESCRIPTION="Quadlet is an opinionated tool for easily running podman system containers under systemd in an optimal way."
HOMEPAGE="https://github.com/containers/quadlet"
SRC_URI="https://github.com/containers/${PN}/archive/${PV}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64"
