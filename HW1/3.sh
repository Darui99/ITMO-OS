S=""
CONCAT=""
while read S
do
	if [ $S = "q" ];
	then
		break
	fi
	CONCAT="${CONCAT}${S}"
done
echo $CONCAT
