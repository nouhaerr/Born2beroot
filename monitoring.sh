#!/bin/bash
arch=$(uname -a)
cpuph=$(grep "physical id" /proc/cpuinfo | sort | uniq | wc -l )
vcpu=$(grep "^processor" /proc/cpuinfo | wc -l)
ramt=$(free -m | awk '$1 == "Mem:" {print $2}')
ramu=$(free -m | awk '$1 == "Mem:" {print $3}')
ramp=$(free -m | awk '$1 == "Mem:" {printf("%.2f"), $3/$2*100}')
tdisk=$(df -Bg | grep '^/dev/' | grep -v '/boot$' | awk '{td += $2} END {print td}')
udisk=$(df -Bm | grep '^/dev/' | grep -v '/boot$' | awk '{ud += $3} END {print ud}')
pdisk=$(df -Bm | grep '^/dev/' | grep -v '/boot$' | awk '{ud += $3} {td +=$2} END {printf("%d"), ud/td*100}')
lcpu=$(top -bn1 | grep '^%Cpu' | awk '{printf("%.1f%%"), $2 + $4}')
lb=$(who -b | awk '$2 == "système" {print $3 " " $4}')
lvm=$(lsblk | grep "lvm" | wc -l)
lvmu=$(if [ $lvm -eq 0 ]; then echo no; else echo yes; fi)
cnxtcp=$(netstat -an | grep ESTABLISHED | wc -l)
ulog=$(users | wc -w)
ip=$(hostname -I)
mac=$(cat /sys/class/net/enp0s3/address)
cmd=$(journalctl _COMM=sudo | grep COMMAND | wc -l)

wall "	#Architecture: $arch
	#CPU physical : $cpuph
	#vCPU : $vcpu
	#Memory Usage : $ramu/${ramt}MB ($ramp%)
	#Disk Usage : $udisk/${tdisk}Gb ($pdisk%)
	#CPU load : $lcpu
	#Last boot : $lb
	#LVM use : $lvmu
	#Connexions TCP : $cnxtcp ESTABLISHED
	#User log: $ulog
	#network: IP $ip ($mac)
	#Sudo : $cmd cmd"
