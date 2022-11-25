#!/bin/bash
#simple menu driven shell script to provide log info about the system.

# Purpose: Display pause prompt
# $1-> Message (optional)
function pause(){
local message="$@"
[ -z $message } && message="Press [Enter] key to continue..."
read -p "$message" readEnterKey
}

# Purpose - Display a menu on screen
function show_menu(){
date
echo "---------------------------"
echo " Main Menu"
echo "---------------------------"
echo "1. Attacker List"
echo "2. Apache Access List"
echo "3. Fail2Ban SSHD Status"
echo "4. Exit"
}

# Purpose - Display header message
# $1 - message
function write_header(){
local h="$@"
echo "---------------------------------------------------------------"
echo " ${h}"
echo "---------------------------------------------------------------"
}

# Purpose - Display attacker info
function attacker_list(){
echo "The following IP Addresses have unsuccessfully attempted to connect to the server:"
awk '/Failed password for/ {x[$(NF-3)]++} END {for (i in x){printf "%3d %s\n", x[i], i}}' /var/log/auth.log | sort -nr
#pause - "Press [Enter] key to conntinue..." 
pause
}

# Purpose - Display Apache access list
function apache_log(){
echo "The following IP Addresses have connected to the webserver:"
awk '{ print $1 } ' /var/log/apache2/access.log | sort -nr | uniq -c
#pause - "Press [Enter] key to conntinue..." 
pause
}

# Purpose - Display Fail2Ban SSHD Jail Status
function fail2ban(){
sudo fail2ban-client status sshd
#pause - "Press [Enter] key to conntinue..." 
pause
}
function read_input(){
local c
read -p "Enter your choice [ 1 - 4 ] " c
case $c in
1) attacker_list ;;
2) apache_log ;;
3) fail2ban ;;
4) echo "Bye...for now..."; exit 0 ;;
*)
echo "Please select between choices 1 and 4 only."
pause
esac
}

# ignore CTRL+C, CTRL+Z and quit signals using the trap
trap '' SIGINT SIGQUIT SIGTSTP

# main logic
while true
do
clear
show_menu # display menu
read_input # wait for user input
done