#!/bin/sh

set -eu

ARCHS="i386,amd64"
ARCHIVE_DISTS="etch"
SECTIONS="main,contrib,non-free,main/debian-installer"


MAIN_DEBIAN_MIRROR="localhost"
MAIN_DEBIAN_MIRROR="archive.debian.org"
MAIN_NAME="debian"


RSYNC_OPTIONS="-aIL --partial --stats --hard-links"

debmirror \
                --arch="${ARCHS}" \
                --dist="${ARCHIVE_DISTS}" \
                --section="${SECTIONS}" \
                --host="${MAIN_DEBIAN_MIRROR}" \
                --root=":archive/debian" \
                --method="rsync" \
                --getcontents \
		--progress	\
		--nosource	\
		-v --debug	\
                --ignore-small-errors \
                --ignore-release-gpg \
                --rsync-options "${RSYNC_OPTIONS}" \
		/srv/mirror/Debian/archive/debian

