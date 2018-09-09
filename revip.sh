#!/usr/bin/env bash
# Simple Reverse IP and CMS Checker
# Coded by Versailles
# Sec7or Team ~ Surabaya Hacker Link
# Special Thanks For Cans21

R='\033[0;31m'
C='\033[0;36m'
Y='\033[1;33m'
O='\033[0;33m'
B='\033[1;34m'
P='\033[0;35m'
G="\e[32m"
W="\e[37m"
N='\033[0m'

cms(){
	get=$(curl -sL "http://$1" -H 'User-Agent: Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/68.0.3440.106 Mobile Safari/537.36')	
	if [[ $get =~ "/sites/default/files/" ]];then
		printf "[$n][  ${Y}Drupal${N}   ] ${P}$1${N}\n"
		echo $1 >> $2/drupal.txt
	elif [[ $get =~ "wp-content" ]];then
		printf "[$n][ ${B}WordPress${N} ] ${P}$1${N}\n"
		echo $1 >> $2/wordpress.txt
	elif [[ $get =~ "com_content" ]];then
		printf "[$n][   ${G}Joomla${N}  ] ${P}$1${N}\n"
		echo $1 >> $2/joomla.txt
	elif [[ $get =~ "/skin/frontend" ]];then
		printf "[$n][  ${O}Magento${N}  ] ${P}$1${N}\n"
		echo $1 >> $2/magento.txt
	elif [[ $get =~ "<script>document.location.href = 'html/index.php';</script>" ]];then
		printf "[$n][ ${R}Balitbang${N} ] ${P}$1${N}\n"
		echo $1 >> $2/balitbang.txt
	elif [[ $get =~ "foto_banner" ]];then
		printf "[$n][ ${C}Lokomedia${N} ] ${P}$1${N}\n"
		echo $1 >> $2/lokomedia.txt
	else
		printf "[$n][  ${W}Unknown${N}  ] ${P}$1${N}\n"
		echo $1 >> $2/unknown.txt
	fi
}

figlet -f small "Simple Reverse Ip"
echo "Made With Love By Versailles <3 Cans21"
read -p '[?] Host/IP : ' host
read -p '[?] Folder Result : ' f
printf "[!] Creating Folder : ${Y}$f${N}\n"
mkdir $f

if [[ $host =~ "http" ]];then
	echo
	echo "Input Without http:// or https://"
	exit 1
else
	get=$(curl -s 'https://viewdns.info/reverseip/?host='$host'&t=1' -H 'Connection: keep-alive' -H 'Upgrade-Insecure-Requests: 1' -H 'User-Agent: Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/68.0.3440.106 Mobile Safari/537.36' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8' -H 'Referer: https://viewdns.info/reverseip/' -H 'Accept-Encoding: gzip, deflate, br' -H 'Accept-Language: en-US,en;q=0.9,id;q=0.8,ru;q=0.7' -H 'Cookie: PHPSESSID=5cf5scn0nuda2jau5m7fdlveg0; __utma=126298514.590573564.1536148295.1536148295.1536148295.1; __utmc=126298514; __utmz=126298514.1536148295.1.1.utmcsr=google|utmccn=(organic)|utmcmd=organic|utmctr=(not%20provided); __utmb=126298514.2.10.1536148295' --compressed )
	ip=$(echo $get | grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b")
	echo $get | grep -Po '(?<=<td>)[^<]*' | sed '/Domain/d' | sed '/Last/d' | sed -e 's/\s/\n/g' | sed '/^$/d' > domains;
	total=$(wc -l domains)
	echo
	printf "[!] IP Address : ${Y}$ip${N}\n"
	printf "[!] Found : ${Y}$total${N}\n"
	echo
		no=1
		for i in $(cat domains);do
			n=$((no++))
			cms $i $f
			sleep 0.5
		done
	echo ""
	printf "[!] All Sites Saved On ${O}domains${N}\n"
	printf "[!] Filtered Sites by CMS Saved On Folder : ${O}$f${N}\n"
	echo "===========[ Done ~ Have A Nice Day ]================="
fi