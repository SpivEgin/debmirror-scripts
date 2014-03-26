#!/bin/sh

set -eu

KARMIC="karmic-backports,karmic-proposed,karmic-security,karmic-updates,karmic"
ARCHS="i386,amd64"
SECTIONS="main,multiverse,restricted,universe"
SECTIONS="main,multiverse,restricted,universe,main/debian-installer,multiverse/debian-installer,universe/debian-installer,restricted/debian-installer"




ARCHIVE_DISTS="${KARMIC}"


MAIN_DEBIAN_MIRROR="localhost"
MAIN_DEBIAN_MIRROR="archive.debian.org"
MAIN_DEBIAN_MIRROR="old-releases.ubuntu.com"

RSYNC_OPTIONS="-aIL --partial --stats --hard-links"

debmirror \
                --arch="${ARCHS}" \
                --dist="${ARCHIVE_DISTS}" \
                --section="${SECTIONS}" \
                --host="${MAIN_DEBIAN_MIRROR}" \
                --root="ubuntu" \
                --method="http" \
                --getcontents \
		--progress	\
		--nosource	\
		-v --debug	\
                --ignore-small-errors \
                --ignore-release-gpg \
                --rsync-options "${RSYNC_OPTIONS}" \
		--nocleanup	\
		/srv/mirror/pub/Ubuntu/old-releases

