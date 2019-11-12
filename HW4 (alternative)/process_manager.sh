#!/bin/bash

function get_short_cmdline {
	CURPID=$1
	CURCMDLINE=$(cat /proc/${CURPID}/cmdline | tr '\0' ' ')
	LEN=${#CURCMDLINE}
	if [ $LEN -gt 50 ];
	then
		CURCMDLINE=${CURCMDLINE:0:50}
		CURCMDLINE="${CURCMDLINE} ..."
	fi
	echo "${CURCMDLINE}"
}

function display_pid_and_cmdline {
	CURPID=$1
	CURCMDLINE=$(get_short_cmdline $CURPID)
	if [ -n "$CURCMDLINE" ];
	then
		echo -e "\e[36m PID: ${CURPID}   |   CMDLINE: ${CURCMDLINE} \e[0m"
	else
		echo -e "\e[36m PID: ${CURPID} \e[0m"
	fi
}

function print_if_isnt_empty {
	if [ -n "$1" ];
	then
		echo -e "\e[36m $2 $1 \e[0m" 
	fi
}

function do_list {
	for CURPID in $(ls /proc | grep -E '^[[:digit:]]+$' | sort -n)
	do
		if [ -d "/proc/${CURPID}" ];
		then
			display_pid_and_cmdline $CURPID
		fi
	done
}

function do_info {
	if ! [ -d "/proc/$1" ];
	then
		echo -e "\e[31m No process with such PID \e[0m"
	else
		CURPID=$1
		display_pid_and_cmdline "${CURPID}"
		CURPPID=$(cat /proc/${CURPID}/status | grep PPid | grep -Eo '[[:digit:]]+')
		PPIDINFO=$(display_pid_and_cmdline ${CURPPID})
		PPIDINFO=${PPIDINFO/PID/PPID}
		PPIDINFO=${PPIDINFO/CMDLINE/PPID CMDLINE}
		echo "${PPIDINFO}"
		print_if_isnt_empty "$(readlink /proc/${CURPID}/exe)" "Path to EXE:"
		print_if_isnt_empty "$(readlink /proc/${CURPID}/cwd)" "Path to CWD:"
		print_if_isnt_empty "$(id -un $(cat /proc/${CURPID}/uid_map | tr -s " " | cut -d " " -f2))" "User:"
		print_if_isnt_empty "$(cat /proc/${CURPID}/statm | cut -d " " -f 1)" "Memory overhead:"
	fi
}

function do_find {
	for CURPID in $(ls /proc | grep -E '^[[:digit:]]+$')
	do
		if [ -d "/proc/${CURPID}" ];
		then
			CURCMDLINE=$(cat /proc/${CURPID}/cmdline | tr -d '\0')
			if [ -n "$CURCMDLINE" ];
			then
				if [[ "${CURCMDLINE}" =~ "$1" ]]
				then
					echo -e "\e[36m PID: ${CURPID} \e[0m"
				fi
			fi
		fi
	done
}

function do_send {
	kill -$1 $2
}

function do_stream {
	trap 'echo ""; trap - SIGINT; return' SIGINT;
	PREVPIDS=$(ls /proc | grep -E '^[[:digit:]]+$')
	ITER=1
	while true
	do
		#echo $ITER
		PIDS=$(ls /proc | grep -E '^[[:digit:]]+$')
		TRASH=""
		for CURPID in $PIDS
		do
			CHECK=$(echo "${PREVPIDS}" | grep ^${CURPID}$)
			if [ -z "${CHECK}" ];
			then
				if [ -d "/proc/${CURPID}" ];
				then
					SCML=$(get_short_cmdline $CURPID)
					echo -e "\e[34m process ${CURPID} (${SCML}) started \e[0m"
				else
					if [ -n "${TRASH}" ];
					then
						TRASH=$(echo "${TRASH}" && echo "${CURPID}")
					else
						TRASH=$(echo "${CURPID}")
					fi
				fi
			fi
		done
		
		for CURPID in $PREVPIDS
		do
			CHECK=$(echo "${PIDS}" | grep ^${CURPID}$)
			if [ -z "${CHECK}" ] && [ $ITER != 1 ];
			then
				echo -e "\e[34m process ${CURPID} finished \e[0m"
			fi
		done
		
		for CURPID in $TRASH
		do
			PIDS=$(echo "${PIDS}" | grep -v ${CURPID})
		done
		PREVPIDS="${PIDS}"
		ITER=$((ITER+1))
	done
}

function do_help {
	echo -e "\e[33m list — выводит список процессов в виде двух столбцов: PID и команда запуска \e[0m"
	echo -e "\e[33m info <PID> — выводит подробную информацию процесса \e[0m"
	echo -e "\e[33m find <QUERY> — выводит список процессов, команда запуска которых содержит запрос \e[0m"
	echo -e "\e[33m send <SIGNAL> <PID> — отправляет сигнал указанному процессу \e[0m"
	echo -e "\e[33m stream — включает режим отслеживания \e[0m"
	echo -e "\e[33m exit — закрывает менеджер \e[0m"
}

while true
do
	echo -en "\e[32m >> \e[0m"
	read INP
	COM=$(cut -d " " -f1 <<< $INP)	
	ARG1=$(cut -d " " -f2 <<< $INP)
	ARG2=$(cut -d " " -f3 <<< $INP)
	echo ""
	case $COM in
	"list" )
		do_list
		;;
	"info" )
		do_info $ARG1
		;;
	"find" )
		do_find $ARG1
		;;
	"send" )
		do_send $ARG1 $ARG2
		;;
	"stream" )
		do_stream
		;;
	"help" )
		do_help
		;;
	"exit" )
		exit 0
		;;
	*)
		echo -e "\e[31m No such command \e[0m"
		;;
	esac
	echo ""
done
