#!/bin/sh

set -eu


ARCHS="i386,amd64"

SYNC_DIST="wheezy jessie sid squeeze"

ARCHIVE_DISTS=""
for dist in ${SYNC_DIST}; do
        ARCHIVE_DISTS="${ARCHIVE_DISTS},${dist}"
        if [ "${dist}" = "sid" ]; then
                continue
        fi
        if [ "${dist}" = "jessie" ]; then
                ARCHIVE_DISTS="${ARCHIVE_DISTS},jessie-proposed-updates"
		continue
        fi
        for p in backports proposed-updates updates; do
            if [ "${dist}" = "squeeze" ] && [ "${p}" = "backports" ]; then
                        continue
                fi
                ARCHIVE_DISTS="${ARCHIVE_DISTS},${dist}-${p}"
        done
done

ARCHIVE_DISTS="${ARCHIVE_DISTS#,}"

#ARCHIVE_DISTS="wheezy,jessie,sid,squeeze"
SECTIONS="main,contrib,non-free,main/debian-installer"

#UPDATES
#ARCHIVE_DISTS="${ARCHIVE_DISTS},squeeze-updates,squeeze-proposed-updates,wheezy-proposed-updates,wheezy-updates,jessie-proposed-updates"
##,lenny-proposed-updates"

MAIN_DEBIAN_MIRROR="archive.debian.org"
MAIN_DEBIAN_MIRROR="localhost"
MAIN_DEBIAN_MIRROR="mirror.yandex.ru"
MAIN_DEBIAN_MIRROR="ftp.by.debian.org"
MAIN_DEBIAN_MIRROR="mirror.datacenter.by"
MAIN_NAME="debian"
DEST_DIR="/srv/mirror/pub/debian"
# 1280

RSYNC_OPTIONS="-v -aIL --partial --stats --hard-links" ## --bwlimit=5120"

SITE=${MAIN_DEBIAN_MIRROR}

MIRROR_CMD=$(echo /srv/debmirror/debmirror \
		--i18n	\
                --arch="${ARCHS}" \
                --dist="${ARCHIVE_DISTS}" \
		--di-arch="${ARCHS}"	\
		--di-dist="wheezy,squeeze" \
                --section="${SECTIONS}" \
                --host="${MAIN_DEBIAN_MIRROR}" \
                --root=":debian" \
                --method="rsync" \
		--rsync-batch=10	\
                --getcontents \
		--progress	\
                --ignore-release-gpg \
                --rsync-options=\"${RSYNC_OPTIONS}\" \
		--rsync-batch=10	\
		--nocleanup	\
		--diff=none	\
		--verbose	\
		${DEST_DIR}
		)

 		#--checksums

. /srv/dmirror/common.sh
sync_mirror
echo "Stage 1 done $?"
echo "Sync with Clean"
MIRROR_CMD=$(echo /srv/debmirror/debmirror \
		--i18n	\
                --arch="${ARCHS}" \
		--di-arch="${ARCHS}"	\
		--di-dist="wheezy,squeeze" \
                --dist="${ARCHIVE_DISTS}" \
                --section="${SECTIONS}" \
                --host="${MAIN_DEBIAN_MIRROR}" \
                --root=":debian" \
                --method="rsync" \
		--rsync-batch=10	\
                --getcontents \
		--progress	\
                --ignore-release-gpg \
                --rsync-options=\"${RSYNC_OPTIONS}\" \
		--rsync-batch=10	\
		--postcleanup	\
		--diff=none	\
		--verbose	\
		--rsync-extra=doc,tools	\
		${DEST_DIR})
sync_mirror 
