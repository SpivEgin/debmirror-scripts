#!/bin/sh

set -eu

export PATH="/usr/local/bin:${PATH}"

ARCHS="i386,amd64"
ARCHIVE_DISTS="squeeze/updates,wheezy/updates,jessie/updates"
SECTIONS="main,contrib,non-free,main/debian-installer"


MAIN_DEBIAN_MIRROR="security.debian.org"

RSYNC_OPTIONS="-aIL --partial --stats --hard-links"
DEST_DIR="/srv/mirror/pub/debian-security/"

SITE=${MAIN_DEBIAN_MIRROR}

MIRROR_CMD=$(echo /srv/debmirror/debmirror \
                --arch="${ARCHS}" \
                --dist="${ARCHIVE_DISTS}" \
                --section="${SECTIONS}" \
                --host="${MAIN_DEBIAN_MIRROR}" \
                --root=":debian-security" \
                --method="rsync" \
                --getcontents \
		--progress	\
		--nosource	\
		--i18n		\
                --ignore-small-errors \
                --ignore-release-gpg \
                --rsync-options=\"${RSYNC_OPTIONS}\" \
		${DEST_DIR})

. /srv/dmirror/common.sh
sync_mirror


