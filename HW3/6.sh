#!/bin/bash
INPUT="${PWD}/info.log"
PREVPID="-1"
SUM="0.0"
CNT=0
while IFS= read -r LINE
do
	CURPID=$(echo "${LINE}" | cut -d ' ' -f 3 | cut -d '=' -f 2)
	CURAVGSLEEP=$(echo "${LINE}" | cut -d ' ' -f 5 | cut -d '=' -f 2)
	if [ $CURPID -ne $PREVPID ];
	then
		if [ $PREVPID -ne "-1" ];
		then
			AVGCH=$(awk 'BEGIN{print ('"$SUM"'/'"$CNT"')}')
			echo "Average_Sleeping_Children_of_ParentID=${PREVPID} is ${AVGCH}"
		fi
		SUM="0.0"
		CNT=0
	fi
	SUM=$(awk 'BEGIN{print ('"$SUM"'+'"$CURAVGSLEEP"')}')
	CNT=$((CNT+1))
	PREVPID=$CURPID
	echo $LINE
done < "${INPUT}"
AVGCH=$(awk 'BEGIN{print ('"$SUM"'/'"$CNT"')}')
echo "Average_Sleeping_Children_of_ParentID=${PREVPID} is ${AVGCH}"
