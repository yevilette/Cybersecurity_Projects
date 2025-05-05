#!/bin/bash


# i) check if applications are installed, otherwise install

echo 'Checking required applications...' 								
echo																	
sleep 1

# check nipe

function ci_nipe()
{
nipe_install=$(dpkg -s cpanminus | grep -i "ok installed" | wc -l )		# dpkg -s to check status and grep if installed

if [ $nipe_install -eq 1 ]												# if installed there should be one line indicating
then
	echo 'Nipe is already installed'
	
else
	echo
	echo 'Installing Nipe'
	echo
	sudo apt-get update													# get update before installation
	git clone https://github.com/htrgouvea/nipe && cd nipe				# install application
	sudo apt-get install cpanminus -y
	cpanm --installdeps .
	sudo cpan install Switch JSON LWP::UserAgent Config::Simple -y
	sudo perl nipe.pl install
	echo
	echo 'Nipe is now installed'
	
fi
}


# check tor

function ci_tor()
{
tor_install=$(dpkg -s tor | grep -i "ok installed" | wc -l )			# dpkg -s to check status and grep if installed

if [ $tor_install -eq 1 ]												# if installed there should be one line indicating
then
	echo 'Tor is already installed'
	
else
	echo
	echo 'Installing Tor'
	echo
	sudo apt-get update													# get update before installation
	sudo apt-get install tor -y											# install application
	echo
	echo 'Tor is now installed'
	
fi
}


function ci_whois()
{
# check whois

whois_install=$(dpkg -s whois | grep -i "ok installed" | wc -l )		# dpkg -s to check status and grep if installed	

if [ $whois_install -eq 1 ]												# if installed there should be one line indicating
then
	echo 'Whois is already installed'
	
else
	echo
	echo 'Installing Whois'
	echo
	sudo apt-get update													# get update before installation
	sudo apt-get install whois -y										# install application
	echo
	echo 'Whois is now installed'
	
fi
}


# check geoiplookup

function ci_geoip()
{
geoip_install=$(dpkg -s geoip-bin | grep -i "ok installed" | wc -l )	# dpkg -s to check status and grep if installed		

if [ $geoip_install -eq 1 ]												# if installed there should be one line indicating
then
	echo 'GeoIPLookup is already installed'
	
else
	echo
	echo 'Installing GeoIPLookup'
	echo
	sudo apt-get update													# get update before installation
	sudo apt-get install geoip-bin geoip-database -y					# install application
	echo
	echo 'GeoIPLookup is now installed'
	
fi
}


# check sshpass

function ci_sshpass()
{
sshpass_install=$(dpkg -s sshpass | grep -i "ok installed" | wc -l )	# dpkg -s to check status and grep if installed		

if [ $sshpass_install -eq 1 ]											# if installed there should be one line indicating
then
	echo 'Sshpass is already installed'
	
else
	echo
	echo 'Installing Sshpass'
	echo
	sudo apt-get update													# get update before installation
	sudo apt-get install sshpass -y										# install application
	echo
	echo 'Sshpass is now installed'
	
fi
}


ci_nipe																	
ci_tor																	
ci_whois																
ci_geoip																
ci_sshpass																


echo																	

# iii) Check if the network connection is anonymous; if not, alert the user and exit

															

perl_install=$(dpkg -s perl | grep -i "ok installed" | wc -l)					# install perl if not already installed

if [ $perl_install -ne 1 ]
then
	sudo perl nipe.pl install

																	
	
fi

sudo updatedb

nipe_dir=$(sudo find / -type d -name nipe 2>/dev/null)							# 2>/dev/null to hide permission denied

cd "$nipe_dir"																	# go to folder with nipe.pl

sudo perl nipe.pl start															# connect through nipe, else exit

nipe_connect=$(sudo perl nipe.pl status | grep -i true | wc -l)
 
if [ $nipe_connect -eq 1 ]
then
	echo "You are anonymous."											
	echo "Connecting to the server..."									
	echo																
	ip=$(curl -s ifconfig.io)											
	echo "Your spoofed IP address is: $ip" 							
	
	ctry=$(geoiplookup $ip | awk -F: '{print $2}')								# iv) If the network connection is anonymous, display the spoofed country name.
	echo "Spoofed country: $ctry" 										
	
else
	echo "Can't connect to server"										
	
	exit
	
fi			


echo																	

# v) Allow the user to specify the address/URL to whois from remote server; save into a variable

echo "Enter IP address or URL to whois from remote server: " 			
read userip																		# 45.33.49.119  scanme3.nmap.com	scanme.nmap.com									
echo																	

echo "Enter IP address of Remote Server: " 								
read rserver																	# 192.168.80.129
echo																	
echo "Enter username of Remote Server: " 								
read ruser																		# tc
echo																	
echo "Enter password of Remote Server: " 							
read rpass																		# tc

ssh_open=$(nmap $rserver | grep open | grep ssh | wc -l)						# 2. Automatically Scan the Remote Server for open ports

echo																												

if [ $ssh_open -eq 1 ]
then 
	echo "Remote Server IP address:"											# display IP of remote server
	echo $rserver														
	echo																	
	echo "Remote Server Country:"											
	whois $rserver | grep -i country | awk -F: '{print $2}' | sed 's/ //g'		# display country of remote server
	echo																
	echo "Remote Server Uptime:"	
	sshpass -p $rpass ssh $ruser@$rserver 'uptime'								# Connect to server via SSH and display IP of remote server

fi


echo																	
echo																	
echo "Running victim's address on whois..."								
echo "..."																

sshpass -p $rpass ssh $ruser@$rserver "whois $userip > $(date +"%d-%m-%Y")whois_$userip"		# 3i) Save the Whois data into file on the remote computer

echo -e "[$(date "+%a %b %d %Y %H:%M:%S")]"  whois data collected for: $userip >> /home/kali/var/log/projnr.log		#3iii, iv) Create a log, audit your data collection, save to local machine

dst=$(pwd)

ftp -in $rserver >/dev/null <<EOF 											# 3ii) Collect the file from the remote computer via FTP
user $ruser $rpass
get $(date +"%d-%m-%Y")whois_$userip $dst/$(date +"%d-%m-%Y")whois_$userip
bye
EOF

echo "...and saving results into $dst/$(date +"%d-%m-%Y")whois_$userip"					
echo

echo																	
echo "Scanning victim's address..."								
echo "..."																


sshpass -p $rpass ssh $ruser@$rserver "nmap -Pn -v0 $userip -oX $(date +"%d-%m-%Y")nmap_$userip.xml"		# Save the nmap data into file on the remote computer

echo -e "[$(date "+%a %b %d %Y %H:%M:%S")]"  nmap data collected for: $userip >> /home/kali/var/log/projnr.log		#3 Create a log, audit your data collection, save to local machine

ftp -in $rserver >/dev/null <<EOF 											# Collect the file from the remote computer via FTP
user $ruser $rpass
get $(date +"%d-%m-%Y")nmap_$userip.xml $dst/$(date +"%d-%m-%Y")nmap_$userip.xml
bye
EOF

echo "...and saving results into $dst/$(date +"%d-%m-%Y")nmap_$userip.xml"					








#meow
