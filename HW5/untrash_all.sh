#!/bin/bash

array=()
while read LINE
do
	array+=("${LINE}")
done < ~/.trash.log

for i in ${!array[@]};
do
	LINE=${array[$i]}
	CNTWORDS=$(echo "${LINE}" | wc -w)
	LINKNAME=$(echo "${LINE}" | cut -d ' ' -f ${CNTWORDS})
	CNTWORDS=$((CNTWORDS-1))
	FPATH=$(echo "${LINE}" | cut -d ' ' -f -${CNTWORDS})
	CNTDIRS=$(echo "${LINE}" | tr ' ' ':' | tr '/' ' ' | wc -w)
	FDIR=$(echo "${FPATH}" | cut -d '/' -f -${CNTDIRS})
	CNTDIRS=$((CNTDIRS+1))
	FNAME=$(echo "${FPATH}" | cut -d '/' -f ${CNTDIRS}-)
	CNTDIRS=$((CNTDIRS-1))
	
	if ! [ ${FNAME} = ${1} ] || ! [[ -f ~/.trash/${LINKNAME} ]]
	then
		continue
	fi
	
	if [[ -d $FDIR ]];
	then
		ln ~/.trash/${LINKNAME} "${FPATH}"
		echo "File ${FPATH} was restored."
	else
		ln ~/.trash/${LINKNAME} ~/${1}
		echo "Original directory is missing. File ${FPATH} was restored in home directory."
	fi
	rm ~/.trash/${LINKNAME}
done
