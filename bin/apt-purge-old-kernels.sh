#!/bin/bash                                                        

kernel_running=`uname -r | cut -c 1-9`                            
kernel_old=`ls /boot | grep vmlinuz | cut -d'-' -f2,3 | sed /$kernel_running/d`

echo -e '\E[1m'"\033[1m### KERNEL CLEANER ###\033[0m"
echo                                                  
echo -e "\033[1mRunning kernel:\033[0m"              
echo -e '\E[32m'"\033[1m$kernel_running\033[0m"                    

echo -e "\033[1mOther (old) kernels:\033[0m"

if [ "$kernel_old" == "" ]; then
    echo -e "\E[33m(None)\033[0m"
    echo
    echo "No old kernels found. Exit."
else
    echo -e '\E[33m'"\033[1m$kernel_old\033[0m"
    echo

    cmd="aptitude purge -P"
    pkgs=`dpkg -l | grep ^ii | grep $kernel_old | awk -F' ' '{ print $2 }'`

    echo "Executing '$cmd' on following packages:"
    echo "$pkgs"
    sudo $cmd $pkgs
fi
