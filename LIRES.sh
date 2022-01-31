#!/bin/bash
###########################################################################
#
#	Script Nane: LIRES - Linux Incident Response Extraction Script
#	Author: Adetomiwa Jeminiwa
#	This script will extract the following:
#		Account info
#		System info
#		Network info
#	This script has been developed for Linux/Unix OS
#	syntax ./LIRES
#
###########################################################################

echo "Welcome to LIRES - Linux Incident Response Extraction Script"

LIRES_System()
{
	echo "LIRES System info"
	echo -e "\n\e[1;31m Hostname: \e[1;m" $(hostname)
	echo -e "\e[1;31m Uptime: \e[1;m" $(uptime)
	echo -e "\e[1;31m OS details: \e[1;m" `uname --all`
	echo -e "\n\e[1;31mMemory usage: \e[1;m\n"
	free -h
	echo -e "\n\e[1;31mFile system Usage: \e[1;m\n"
	df -h
#	echo sudo fdisk -l #requires sudo or run as root
	echo -e "\n\e[1;31mSystem Partitions: \e[1;m"
	cat /proc/partitions 
	echo -e "\n\e[1;31mCPU Info: \e[1;m"
 	cat /proc/cpuinfo  # confirm where folder is 

}

LIRES_Network()
{
	echo "LIRES Network info"
	echo ifconfig -a
	ifconfig -a
	echo "Firewall rules: "
#	sudo iptables -L -v #requires sudo	
	echo netstat
	netstat

}

LIRES_Account()
{
	echo -e "\e[1;31mLIRES Account info \e[1;m"
	echo -e "\n\e[1;31mCurrently logged-on system users: \e[1;m"
	w
	echo -e "\n\e[1;31mCurrently logged-on users: \e[1;m"
	who
#	echo -e "Shadow file: " requires sudo
#	sudo cat /etc/shadow
	echo -e "\n\e[1;31mUser Groups: \e[1;m"
	cat /etc/group  #use 'cut -d: -f1'  to format output 


}

LIRES_Process()
{
#	echo "Schedule jobs: " `crontab` #For shceduled jobs
	echo "System processes"
	ps -aux
	echo "List and Status of System Services: " #Can also use 'systemctl'
	service --status-all
	echo "Running processes: "
#	top -commented out 


}

LIRES_Logs()
{
#	sudo cat /var/log/messages #For system activity logs; requires sudo
#	sudo cat /var/log/auth.log #For authentication events/logs
#	cat /var/log/faillog OR faillog -u <user> #For failed user login attempts
	echo 'Commented function'
}

#Declaring variables
dt= $(date -u)

#Function call
LIRES_System
echo $(LIRES_System) > LIRES_System.txt #To export in text file
LIRES_Network
LIRES_Account
LIRES_Process

echo -e "\n\e[1;31mWe are done collecting data for this incident!\e[1;m"
