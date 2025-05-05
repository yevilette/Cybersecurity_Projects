#!/usr/bin/python3

import time

file_path = "/var/log/auth.log"

with open(file_path, "r") as f:											# code to parse the file
	content = f.read().splitlines()										# read file without new lines

# ~ print(content)														# to check content of log
	
print("Analysing /var/log/auth.log ... \n")								# informing user purpose of script

print("Commands used:\n")
time.sleep(1)
		
for line in content:													# extracting lines with commands
	if "COMMAND" in line:
		print(line)



# ~ with open(file_path,'r') as file:										# couldn't get the script to print kali as user for some reason....
	# ~ for line in file:
		# ~ ' '.join(line.split(' '))										# tried to remove multiple white space in front of kali user - didn't work
		# ~ if "COMMAND" in line:
			# ~ parts = line.split(' ')										# splitting into parts to extract relevant info
			# ~ timestamp = parts[0]
			# ~ user = parts[3]
			# ~ command = ' '.join(parts[11:])
			# ~ print(f"Timestamp: {timestamp}, User: {user}, {command}")	# print timestamp, user, command


time.sleep(2)

print("\nOther relevant information:\n")


for line in content:													
	if "adduser" in line:													# extracting lines with newly added users
		parts = line.split(' ')												# splitting into parts to extract relevant info
		timestamp = parts[0]
		newuser = parts[-1]
		print(f"New user {newuser} added at {timestamp}")					# print newly added users with timestamp
		


print(" ")
time.sleep(2)

for line in content:													
	if "delete user" in line:												# extracting lines with deleted users
		parts = line.split(' ')												# splitting into parts to extract relevant info
		timestamp = parts[0]
		deluser = parts[-1]
		print(f"User {deluser} was deleted at {timestamp}")					# print deleted users with timestamp



print(" ")
time.sleep(2)

for line in content:													
	if "password changed" in line:											# extracting lines with changing passwords
		parts = line.split(' ')												# splitting into parts to extract relevant info
		timestamp = parts[0]
		pswch = ' '.join(parts[-4:])
		print(f"{timestamp} {pswch}")										# print password changes with timestamp



print(" ")
time.sleep(2)


print("su commands used: ")
time.sleep(1)

for line in content:												
	if "su" and "(to" in line:											# extracting lines with su and to which user it was switched
		print(line)														# print lines with su commands
		
		

print(" ")
time.sleep(2)


print("Users who used sudo commands: ")
time.sleep(1)

for line in content:												
	if "sudo" and "COMMAND" in line:										# extracting lines with sudo and command
		parts = line.split(';')												# splitting into parts to extract relevant info
		details = parts[0]
		commands = ' '.join(parts[3:])
		print(f"{details} {commands}")										# print lines with sudo commands	

		

print(" ")
time.sleep(2)


print("ALERT! Failed attempt to use sudo command: ")
time.sleep(1)

for line in content:												
	if "sudo" and "attempt" in line:										# extracting lines with sudo and attempt
		parts = line.split(';')												# splitting into parts to extract relevant info
		details = parts[0]
		commands = ' '.join(parts[3:])
		print(f"{details} {commands}")										# print lines with sudo commands	

		




























																			#meow




