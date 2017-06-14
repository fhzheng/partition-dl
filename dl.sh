#! /bin/bash
#color definitions(Ref https://stackoverflow.com/questions/5947742/how-to-change-the-output-color-of-echo-in-linux/28938235#28938235)
#=====START=====
# Reset
Color_Off='\033[0m'       # Text Reset

# Regular Colors
Black='\033[0;30m'        # Black
Red='\033[0;31m'          # Red
Green='\033[0;32m'        # Green
Yellow='\033[0;33m'       # Yellow
Blue='\033[0;34m'         # Blue
Purple='\033[0;35m'       # Purple
Cyan='\033[0;36m'         # Cyan
White='\033[0;37m'        # White

# Bold
BBlack='\033[1;30m'       # Black
BRed='\033[1;31m'         # Red
BGreen='\033[1;32m'       # Green
BYellow='\033[1;33m'      # Yellow
BBlue='\033[1;34m'        # Blue
BPurple='\033[1;35m'      # Purple
BCyan='\033[1;36m'        # Cyan
BWhite='\033[1;37m'       # White

# Underline
UBlack='\033[4;30m'       # Black
URed='\033[4;31m'         # Red
UGreen='\033[4;32m'       # Green
UYellow='\033[4;33m'      # Yellow
UBlue='\033[4;34m'        # Blue
UPurple='\033[4;35m'      # Purple
UCyan='\033[4;36m'        # Cyan
UWhite='\033[4;37m'       # White

# Background
On_Black='\033[40m'       # Black
On_Red='\033[41m'         # Red
On_Green='\033[42m'       # Green
On_Yellow='\033[43m'      # Yellow
On_Blue='\033[44m'        # Blue
On_Purple='\033[45m'      # Purple
On_Cyan='\033[46m'        # Cyan
On_White='\033[47m'       # White

# High Intensity
IBlack='\033[0;90m'       # Black
IRed='\033[0;91m'         # Red
IGreen='\033[0;92m'       # Green
IYellow='\033[0;93m'      # Yellow
IBlue='\033[0;94m'        # Blue
IPurple='\033[0;95m'      # Purple
ICyan='\033[0;96m'        # Cyan
IWhite='\033[0;97m'       # White

# Bold High Intensity
BIBlack='\033[1;90m'      # Black
BIRed='\033[1;91m'        # Red
BIGreen='\033[1;92m'      # Green
BIYellow='\033[1;93m'     # Yellow
BIBlue='\033[1;94m'       # Blue
BIPurple='\033[1;95m'     # Purple
BICyan='\033[1;96m'       # Cyan
BIWhite='\033[1;97m'      # White

# High Intensity backgrounds
On_IBlack='\033[0;100m'   # Black
On_IRed='\033[0;101m'     # Red
On_IGreen='\033[0;102m'   # Green
On_IYellow='\033[0;103m'  # Yellow
On_IBlue='\033[0;104m'    # Blue
On_IPurple='\033[0;105m'  # Purple
On_ICyan='\033[0;106m'    # Cyan
On_IWhite='\033[0;107m'   # White

#Reset
Reset='\x1b[m'
#=====END=====
declare proxies
proxies=(
	[m1]="192.168.1.11|user|pass"
	[m2]="192.168.1.12|user|pass"
	[m3]="192.168.1.13|user|pass"
	[m4]="192.168.1.14|user|pass"
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
			echo -e "${Red}Fanghu's distributed download application!${Reset}${Yellow}<fhzheng@iflytek.com>${Reset}\n${Green}DOWNLOAD:${Reset}\n\t-r range: HTTP Range\n\t-p proxy: Proxy\n\t-a archive: Download archive\n\t-n filename: Filename\n${Green}MISC:${Reset}\n\t-s proxy: Proxy's status\n\t-g machine: Log into specificed machine\n\t-h: Help\n\t-l: List proxies"
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

