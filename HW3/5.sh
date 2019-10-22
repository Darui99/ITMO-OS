#!/bin/bash
PIDS=$(ps -axu | sed 1d | tr -s ' ' | cut -d ' ' -f 2 | tr '\n' ' ')
for CURPID in $PIDS
do
	CURPPID=$(cat 2>/dev/null "/proc/${CURPID}/status" | sed 7!d | grep -Eho '[[:digit:]]+')
	SUMEXEC=$(cat 2>/dev/null "/proc/${CURPID}/sched" | grep -h sum_exec_runtime | tr -s ' ' | cut -d ' ' -f 3)
	NRSWITCHES=$(cat 2>/dev/null "/proc/${CURPID}/sched" | grep -h nr_switches | tr -s ' ' | cut -d ' ' -f 3)
	if [ -z "$CURPPID" ] || [ -z "$SUMEXEC" ] || [ -z "$NRSWITCHES" ];
	then
		continue
	fi
	SLEEPAVG=$(awk 'BEGIN{print ('"$SUMEXEC"'/'"$NRSWITCHES"')}')
	echo "ProcessID=${CURPID} : Parent_ProcessID=${CURPPID} : Average_Sleeping_Time=${SLEEPAVG}" >> tmpinfo.log
done
sort tmpinfo.log -t '=' -k3 -h > info.log
rm tmpinfo.log
