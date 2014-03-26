export PATH="/usr/bin:/usr/local/bin:/bin:${PATH}"

LOCK_FILE="Archive-Update-in-Progress-$(hostname -f)_common"
LOG="/tmp/`basename $0`.log.$(date +'%s')"
LOCK="${DEST_DIR}/${LOCK_FILE}"


## save logs
exec 1>>${LOG}
exec 2>&1

trap sig_handler 1 2 3 15 9

#set -x

sig_handler () {
	local trapme=$(trap)
	if [ -f "${LOCK}" ]; then
		rm -f $LOCK 
	fi
	echo "$(date) sig handler clenup..." 
	exit 1
}

check_lock () {
	PID=$(cut -f1 -d: ${LOCK})
	echo "test PID ${PID}"

	if pgrep -P ${PID} > /dev/null; then
		echo "Found running process with pid."
		return 0
	else
		echo "Remove stale lock."
		rm -f $LOCK
		return 1
	fi

}

create_lock () {
	echo "$$" > ${LOCK}
}

__sync_mirror() {
    
    if [ -f ${LOCK}  ]; then
	if check_lock; then
		echo "Lock File Present! [$(date)]" && exit 0
	fi
    fi

#    if [ -n "$1" ]; then
#     if [ "$1" = "1" ]; then
    	create_lock
#     fi

    k=0
    while sleep 20; do 
	echo "`date`"
	echo "Run: ${MIRROR_CMD}"
	if sh -c "$MIRROR_CMD"; then
		return 0
	fi
	k=$(expr $k + 1)
	[ $k -ge 20 ] && return 1
    done
}

sync_mirror() {
	local status=0;
	local sep="`echo -e '\x00'`"

	if __sync_mirror; then
		echo "$(basename $0) syned at $(date) with ${SITE}."
		status=1;
	else
		echo "$(basename $0) NO syned at $(date) with ${SITE}."
		status=0;
	fi
}

