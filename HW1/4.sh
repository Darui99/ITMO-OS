X=0
CNT=0
while read X
do
	if [ $((X%2)) = 0 ];
	then
		break
	fi
	CNT=$((CNT+1))
done
echo $CNT
