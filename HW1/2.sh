if [ $# == 3 ];
then
	MAX=$1
	if [ $2 -gt $MAX ];
	then
		MAX=$2
	fi
	if [ $3 -gt $MAX ];
	then
		MAX=$3
	fi
	echo $MAX
else
	echo "Count of arguments must be 3"
fi
