#!/bin/bash

LASTBACKUP=""

for CURDIR in $(ls ~/)
do
	if ! [[ -d ~/${CURDIR} ]] || ! [[ ${CURDIR} =~ Backup-[0-9]{4}-[0-9]{2}-[0-9]{2} ]];
	then
		continue
	fi
	LASTBACKUP=${CURDIR}
done

if [ -z ${LASTBACKUP} ];
then
	echo "No backups"
	exit 0
fi

LBD=$(echo "${LASTBACKUP}" | cut -d '-' -f 2-)

if ! [[ -d ~/restore ]];
then
	mkdir ~/restore
fi

for CURFILE in $(ls ~/${LASTBACKUP})
do
	if [[ ${CURFILE} =~ \.[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]];
	then
		continue
	fi
	cp ~/${LASTBACKUP}/${CURFILE} ~/restore/${CURFILE}
done
