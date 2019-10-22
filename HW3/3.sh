#!/bin/bash
echo -n "" > sbin_files.log
PIDS=$(ps -axu | sed 1d | tr -s ' ' | cut -d ' ' -f 2)
for CURPID in $PIDS
do
	COM=$(readlink /proc/$CURPID/exe)
	if [[ $COM =~ ^/bin/.* ]];
	then
		echo "${CURPID}:${COM}" >> sbin_files.log
	fi
done
