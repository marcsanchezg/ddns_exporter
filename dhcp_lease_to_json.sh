#!/bin/bash

json="["


dhcp-lease-list | awk '{print $3, $1, $2}' | uniq | sed -e '1,3d' | grep -v "\-NA\-" > /tmp/ddns_exporter_lease.list

while read l; do
	json="$json\n\t{"
	json="$json\n\t\t\"nameserver\": \"$(echo $l | awk '{print $1}')\","
	json="$json\n\t\t\"mac\": \"$(echo $l | awk '{print $2}')\","
	json="$json\n\t\t\"address\": \"$(echo $l | awk '{print $3}')\""
	json="$json\n\t},"

done < /tmp/ddns_exporter_lease.list

rm /tmp/ddns_exporter_lease.list

json="$json\n]"
json=$(echo $json | sed 's/\\n\\t\}\,\\n\]/\\n\\t\}\\n]/g')


echo -e $json
