#!/bin/bash

LASTBACKUP=""
SSTT=$(date +"%F %T")
SSTD=$(date +%F)

for CURDIR in $(ls ~/)
do
	if ! [[ -d ~/${CURDIR} ]] || ! [[ ${CURDIR} =~ Backup-[0-9]{4}-[0-9]{2}-[0-9]{2} ]];
	then
		continue
	fi
	LASTBACKUP=${CURDIR}
done

LBDATE=$(echo "${LASTBACKUP}" | cut -d '-' -f 2-)
LBTS=$(date --date=${LBDATE} +%s)
LBTS=$((LBTS+604800))
CTS=$(date +%s)

if [ -z ${LASTBACKUP} ] || [[ ${LBTS} -lt ${CTS} ]];
then
	NBN="Backup-$(date +%F)"
	mkdir ~/${NBN}
	echo "Created ${NBN} ${SSTT}" >> ~/backup-report
	
	for CURFILE in $(ls ~/source)
	do
		cp ~/source/${CURFILE} ~/${NBN}
		echo "~/source/${CURFILE} was copied to ~/${NBN}" >> ~/backup-report
	done
else
	echo "Updated ${LASTBACKUP} ${SSTT}" >> ~/backup-report
	for CURFILE in $(ls ~/source)
	do
		if ! [[ -f ~/${LASTBACKUP}/${CURFILE} ]];
		then
			cp ~/source/${CURFILE} ~/${LASTBACKUP}/${CURFILE}
			echo "~/source/${CURFILE} was copied to ~/${LASTBACKUP}" >> ~/backup-report
		else
			OLDSZ=$(stat ~/${LASTBACKUP}/${CURFILE} -c%s)
			NEWSZ=$(stat ~/source/${CURFILE} -c%s)
			if [ ${OLDSZ} -ne ${NEWSZ} ];
			then
				mv ~/${LASTBACKUP}/${CURFILE} ~/${LASTBACKUP}/${CURFILE}.${SSTD}
				cp ~/source/${CURFILE} ~/${LASTBACKUP}/${CURFILE}
				echo "~/source/${CURFILE} changed. Old version: ~/${LASTBACKUP}/${CURFILE}.${SSTD}" >> ~/backup-report
			fi
		fi
	done
fi
