#!bin/bash

#display the OS's architecture and its kernel version
arch=$(uname -a)

#number of physical processors
pcpu=$(grep "physical id" /proc/cpuinfo | uniq | wc -l)

#number of vCPU's
vcpu=$(grep -c "processor" /proc/cpuinfo)

#current available RAM and its utilization as a percentage
ram=$(free --mega | grep "Mem:" | awk '{printf("%i/%iMB (%.2f%%)", $3, $2, $3/$2 * 100)}')

#current disk usage
disk=$(df -BM --total | grep "total" | awk '{printf("%i/%iMB (%.2f%%)", $3, $2, $3/$2 * 100)}')

#current utilization rate of the processors
cpusage=$(top -ibn1 | grep "%Cpu" | tr "," " " | awk '{printf("%.1f%%", (100 - $8))}')

#date and hour of the last machine boot
lstboot=$(who -b | awk '{print $3 " " $4}')

#currebt state of LVM (active or not)
LVMstat=$(if [ $(lsblk | grep -c "lvm") -eq 0 ]; then echo "no"; else echo "yes"; fi)

#number of active connections
conTCP=$(ss -s | grep "TCP:" | awk '{print $4}' | tr -d ",")

#number of users currently logged in
usrs=$(who | wc -l)

#IPv4 address and its MAC address
IP=$(hostname -I)
MAC=$(ip link | grep "ether" | awk '{print $2}' | head -1)

#number of command executed with sudo
sudo=$(journalctl -q | grep "sudo" | grep "COMMAND" | wc -l)
	
wall " 	 	#Architecture:		$arch
		#Physical CPU:		$pcpu
		#Virtual CPU:		$vcpu
		#Memory Usage:		$ram
		#Disk Usage:		$disk
		#CPU Load:		$cpusage
		#Last Boot:		$lstboot
		#LVM use:		$LVMstat
		#Connections TCP:	$conTCP ESTABLISHED
		#User log:		$usrs
		#Network:		IP $IP ($MAC)
		#Sudo:			$sudo cmd
"
