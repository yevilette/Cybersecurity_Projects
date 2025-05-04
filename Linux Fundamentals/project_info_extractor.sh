#!/bin/bash

echo 'Hello, Human on this machine!'
echo
sleep 0.4

#using curl command to find public IP add
ext_ip=$(curl -s ifconfig.io)											

echo 'Your public IP address is:'
echo "$ext_ip"		
echo
sleep 1

#use ifconfig, grep and awk to find and narrow down internal IP add
int_ip=$(ifconfig | grep broadcast | awk '{print $2}')					

echo 'Your internal IP address is:'
echo "$int_ip"
echo
sleep 1

#use ifconfig, grep and awk to narrow down mac address and output only last 24 bits																			
mac_add4=$(ifconfig | grep ether | awk '{print $2}' | awk -F: '{print $4}')		
mac_add5=$(ifconfig | grep ether | awk '{print $2}' | awk -F: '{print $5}')
mac_add6=$(ifconfig | grep ether | awk '{print $2}' | awk -F: '{print $6}')

echo 'The MAC address of your machine is:'
echo "XX:XX:XX:$mac_add4:$mac_add5:$mac_add6"
echo
sleep 1


echo "CPU usage (%) for the top 5 processes are:"																
sleep 1

#using command top to show processes' CPU usage % with -b for batch mode and -n 1 output single snapshot
#using awk to only output PID, user, CPU usage % and command
#using while loop and sleep to slow down output with multiple lines

top -b -n 1 | head -12 | tail -6 | awk '{print $1, $2, $9, $12}' | column -t  | while read line; do				
    echo "$line"											
    sleep 0.4
done					
echo
sleep 2


echo 'Memory usage statistics:'						
sleep 1

#using ps and free commands to display memory usage
#using ps aux to list all running processes with detailed information for each, and --sort -%mem to sort and list processes consuming the most memory first
#using while loop and sleep to slow down output with multiple lines

ps aux --sort -%mem | while read line; do								
    echo "$line"														
    sleep 0.1
done
echo
sleep 1

#using free and -h to output system's memory usage in human-readable format with auto selection of units and awk to display required column

tm=$(free -h | head -2 | tail -1 | awk '{print $2}')			
echo "Total Memory: $tm"
sleep 1

um=$(free -h | head -2 | tail -1 | awk '{print $3}')
echo "Used Memory: $um"
sleep 1

am=$(free -h | head -2 | tail -1 | awk '{print $NF}')
echo "Available Memory: $am"
echo
sleep 1


echo 'Your Active System services are:'		
sleep 1

#using systemd to display list of all currently running services and while loop and sleep to slow down output with multiple lines

systemctl --type=service --state=running | grep active | while read line; do				
    echo "$line"
    sleep 0.4
done
echo
sleep 2


echo 'Your top 10 largest files are:'
sleep 1

#using superuser privileges to search all files in home directory and -exec runs the du -h command on each file, displaying disk usage of a file in human-readable format. sort -rh does human-readable sorting displaying largest file first.
#using while loop and sleep to slow down output with multiple lines

sudo find /home -type f -exec du -h {} + | sort -rh | head -n 10 | while read line; do			
    echo "$line"																				
    sleep 0.4
done		
echo
sleep 2























echo
echo 'Have a good day and be kind to cats :)'
sleep 0.4
