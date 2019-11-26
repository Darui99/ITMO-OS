#!/bin/bash

if ! [[ -f ${1} ]];
then
	echo "No such file"
	exit 0
fi

if ! [[ -d ~/.trash ]];
then
	mkdir ~/.trash
fi

MEX=$(cat ~/.trash.log | wc -l)
ln ${1} ~/.trash/${MEX}
echo "${PWD}/${1} ${MEX}" >> ~/.trash.log
rm ${1}
