#!/bin/ash

HOST_LIST=/tmp/myhostlist
TMP_HOSTS=/tmp/block.hosts.unsorted
HOSTS=/tmp/block.hosts

# remove any old TMP_HOSTS that might have stuck around
rm ${TMP_HOSTS} 2> /dev/null
rm ${HOST_LIST} 2> /dev/null

# Download the host file list
wget -i ${HOST_LIST} -qO- | grep -v '^#'  | wget -i- -qO- | grep -v -e "^#" -e "^\s*$" -e "\blocalhost\b" | sed -E -e "s/^127.0.0.1/0.0.0.0/" -e "s/#.*$//" -e "s/\t/ /" -e "s/[[:space:]]{2,}/ /" | tr -d "\r" >> ${TMP_HOSTS}

# remove duplicate hosts and save the real hosts file
sort ${TMP_HOSTS} | uniq > ${HOSTS}



#rm ${TMP_HOSTS} 2> /dev/null
#rm ${HOST_LIST} 2> /dev/null

killall -s SIGHUP dnsmasq
