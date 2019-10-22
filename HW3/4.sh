#!/bin/bash
PIDS=$(ps -axu | sed 1d | tr -s ' ' | cut -d ' ' -f 2 | tr '\n' ' ')
for CURPID in $PIDS
do
	RESIDENT=$(cat 2>/dev/null "/proc/${CURPID}/statm" | cut -d ' ' -f 2)
	SHARE=$(cat 2>/dev/null "/proc/${CURPID}/statm" | cut -d ' ' -f 3)
	if [ -z "$RESIDENT" ] || [ -z "$SHARE" ];
	then
		continue
	fi
	DIF=$((RESIDENT-SHARE))
	echo "${CURPID}:${DIF}" >> difftmp.log
done
sort difftmp.log -t ':' -k2 -rn > diff.log
rm difftmp.log
