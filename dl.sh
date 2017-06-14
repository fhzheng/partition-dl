#! /bin/bash
#color definitions(Ref https://stackoverflow.com/questions/5947742/how-to-change-the-output-color-of-echo-in-linux/28938235#28938235)
#=====START=====
# Regular Colors
Green='\033[0;32m'        # Green
Yellow='\033[0;33m'       # Yellow
Purple='\033[0;35m'       # Purple

#Reset
Reset='\x1b[m'
#=====END=====
declare proxies
proxies=(
	"192.168.1.11|user|pass"
	"192.168.1.12|user|pass"
	"192.168.1.13|user|pass"
	"192.168.1.14|user|pass"
	)

RANGE="Nah"
PROXY="Nah"
URL="Nah"
SHOW_STATUS="Nah"
FILENAME="Nah"
GOTO_MACHINE="Nah"
SCMD="Nah"
while getopts "r:p:a:s:n:g:hl" arg
do
	case $arg in
		r)
			#echo "range's arg:$OPTARG"
			RANGE=$OPTARG
			;;
		p)
			#echo "proxy's arg:$OPTARG"
			PROXY=$OPTARG
			;;
		a)
			#echo "url's arg:$OPTARG"
			URL=$OPTARG
			;;
		s)
			#echo "status's arg:$OPTARG"
			SHOW_STATUS=$OPTARG
			;;
		n)
			FILENAME=$OPTARG
			;;
		g)
			GOTO_MACHINE=$OPTARG
			;;
		l)
			for key in $(echo ${!proxies[*]})
			do
				output=`echo ${proxies[$key]} | cut -d "|" -f1`
				echo -e ${Green}${key}${Reset} \=\> ${output}
			done
			exit 1
			;;
		h)
			echo -e "${Red}Fanghu's distributed download application!${Reset}${Yellow}<mtdwss@gmail.com>${Reset}\n${Green}DOWNLOAD:${Reset}\n\t-r range: HTTP Range, n-m\n\t-p proxy: Proxy number listed in the -l command\n\t-a archive: Download archive\n\t-n filename: Filename\n${Green}MISC:${Reset}\n\t-s proxy: Proxy's status\n\t-g machine: Log into specificed machine\n\t-h: Help\n\t-l: List proxies"
			exit 1
			;;
		?)
		echo "unknow argument"
	exit 1
	;;
	esac
done
if [ $SHOW_STATUS != "Nah" ];then
	proxy=${proxies[$SHOW_STATUS]}
	ip=`echo $proxy | cut -d "|" -f1`
	pass=`echo $proxy | cut -d "|" -f3`
	user=`echo $proxy | cut -d "|" -f2`
	SCMD="sshpass -p $pass ssh -l $user $ip \"tail -fn1000 nohup.out\""
elif [ $RANGE != "Nah" -a $PROXY != "Nah" -a $URL != "Nah" -a $FILENAME != "Nah" ];then
	proxy=${proxies[$PROXY]}
	pass=`echo $proxy | cut -d "|" -f3`
	ip=`echo $proxy | cut -d "|" -f1`
	user=`echo $proxy | cut -d "|" -f2`
	DCMD="nohup curl -O $FILENAME.$RANGE.tmp -r ${RANGE} ${URL} > nohup.out 2>&1 &"
	SCMD="sshpass -p $pass ssh -l $user $ip \"$DCMD\""
elif [ $GOTO_MACHINE != "Nah"  ];then
	machine=${proxies[$GOTO_MACHINE]}
	pass=`echo $machine | cut -d "|" -f3`
	ip=`echo $machine | cut -d "|" -f1`
	user=`echo $machine | cut -d "|" -f2`
	SCMD="sshpass -p $pass ssh $user@$ip"
else
	echo -e "WARNING Arguments not enough!\nUse '-h' to view all options"
	exit 1
fi
echo ">> "$SCMD
eval $SCMD

