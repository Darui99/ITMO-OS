echo "press 1 to start nano"
echo "press 2 to start vi"
echo "press 3 to start links"
echo "press 4 to quit"
OPT=0
while true
do
	echo -n ">> "
	read OPT
	case $OPT in
	1 )
		nano
		;;
	2 )
		vi
		;;
	3 )
		links
		;;
	4 )
		exit 0
		;;
	esac
done
