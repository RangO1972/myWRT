#!/bin/ash

HOST_LIST=/tmp/host_servers.txt
TMP_HOSTS=/tmp/block.hosts.unsorted
HOSTS=/tmp/block.hosts

# remove any old TMP_HOSTS that might have stuck around
rm ${TMP_HOSTS} 2> /dev/null
rm ${HOST_LIST} 2> /dev/null



# grab a hosts file list and...
# filter out comment lines
# filter out empty lines
# replace double+ spaces with single spaces
# remove carriage returns
#wget -qO- "https://raw.githubusercontent.com/RangO1972/myWRT/master/host_servers.txt" | grep -v -e "^#" -e "^\s*$" | sed -E -e "s/[[:space:]]{2,}/ /" | tr -d "\r" >> ${HOST_LIST}

# grab a hosts file list and...
# filter out comment lines
# filter out empty lines
# filter out localhost entries (the router is handling localhost)
# replace 127.0.0.1 with 0.0.0.0
# remove trailing comments
# replace tabs with spaces
# replace double+ spaces with single spaces
# remove carriage returns

wget -i ${HOST_LIST} -qO- | grep -v -e "^#" -e "^\s*$" -e "\blocalhost\b" | sed -E -e "s/^127.0.0.1/0.0.0.0/" -e "s/#.*$//" -e "s/\t/ /" -e "s/[[:space:]]{2,}/ /" | tr -d "\r" >> ${TMP_HOSTS}

# remove duplicate hosts and save the real hosts file
sort ${TMP_HOSTS} | uniq > ${HOSTS}



#rm ${TMP_HOSTS} 2> /dev/null
#rm ${HOST_LIST} 2> /dev/null

#killall -s SIGHUP dnsmasq
