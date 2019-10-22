#!/bin/bash
PIDS=$(ps -axu | sed 1d | tr -s ' ' | cut -d ' ' -f 2)
for CURPID in $PIDS
do
	DIR=$(readlink /proc/${CURPID}/cwd)
	if [ -n "$DIR" ];
	then
		echo $DIR
	fi
done | sort | uniq > uniq_cwd.log
