if [ $# == 2 ];
then
	if [ $1 = $2 ];
	then
		echo "Strings are equal"
	else
		echo "Strings are not equal"
	fi
else
	echo "Count of arguments must be 2"
fi
