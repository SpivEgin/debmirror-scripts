#!/bin/sh

set -eu

export PATH="/usr/local/bin:${PATH}"

ARCHS="i386,amd64"

HARDY="hardy-backports,hardy-proposed,hardy-security,hardy-updates,hardy"
KARMIC="karmic-backports,karmic-proposed,karmic-security,karmic-updates,karmic"
LUCID="lucid-backports,lucid-proposed,lucid-security,lucid-updates,lucid"
MAVERICK="maverick-backports,maverick-proposed,maverick-security,maverick-updates,maverick"
NATTY="natty-backports,natty-proposed,natty-security,natty-updates,natty"
ONEIRIC="oneiric-backports,oneiric-proposed,oneiric-security,oneiric-updates,oneiric"
PRECISE="precise-backports,precise-proposed,precise-security,precise-updates,precise"
QUANTAL="quantal-updates,quantal-security,quantal-proposed,quantal-backports,quantal"
RARING="raring-updates,raring-security,raring-proposed,raring-backports,raring"
SAUCY="saucy-updates,saucy-security,saucy-proposed,saucy-backports,saucy"

#ARCHIVE_DISTS="${MAVERICK}"
ARCHIVE_DISTS="${HARDY},${LUCID},${ONEIRIC},${PRECISE},${QUANTAL},${RARING},${SAUCY}"
SECTIONS="main,multiverse,restricted,universe,main/debian-installer,multiverse/debian-installer,universe/debian-installer,restricted/debian-installer"


MAIN_DEBIAN_MIRROR="archive.debian.org"
MAIN_DEBIAN_MIRROR="localhost"
MAIN_DEBIAN_MIRROR="mirror.yandex.ru"
MAIN_DEBIAN_MIRROR="mirror.datacenter.by"
MAIN_NAME="ubuntu"
DEST_DIR="/srv/mirror/pub/ubuntu"
# 1280

# --bwlimit=5120
RSYNC_OPTIONS="-aILz --partial --hard-links --timeout=360 --quiet"
RSYNC_OPTIONS="-aILz --partial --hard-links --timeout=360 -v"

SITE=${MAIN_DEBIAN_MIRROR}

MIRROR_CMD=$(echo /srv/debmirror/debmirror \
                --arch="${ARCHS}" \
                --dist="${ARCHIVE_DISTS}" \
                --section="${SECTIONS}" \
                --host="${MAIN_DEBIAN_MIRROR}" \
                --root=":${MAIN_NAME}" \
                --method="rsync" \
                --getcontents \
		--nosource	\
                --ignore-release-gpg \
                --rsync-options=\"${RSYNC_OPTIONS}\" \
		--rsync-batch=10	\
		--nocleanup \
		--diff=none	\
		--i18n		\
		--verbose	\
		--debug		\
		${DEST_DIR}
		)


. /srv/dmirror/common.sh
sync_mirror 

MIRROR_CMD=$(echo /srv/debmirror/debmirror \
                --arch="${ARCHS}" \
                --dist="${ARCHIVE_DISTS}" \
                --section="${SECTIONS}" \
                --host="${MAIN_DEBIAN_MIRROR}" \
                --root=":${MAIN_NAME}" \
                --method="rsync" \
                --getcontents \
		--nosource	\
                --ignore-release-gpg \
                --rsync-options=\"${RSYNC_OPTIONS}\" \
		--rsync-batch=10	\
		--postcleanup		\
		--diff=none	\
		--i18n		\
		--verbose	\
		--debug		\
		${DEST_DIR}
		)

sync_mirror 
