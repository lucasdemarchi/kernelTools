#!/bin/bash

print_usage() {

cat - <<EOF
Given a file with timestamps with two collumns with the following format
SECS NSECS

It creates another file (appending .latecy in name) with the difference between
two timestamps

USAGE:
	generate_latencies.sh arrival_timestamps1 [arrival_timestamps2] .. [arrival_timestampsN]

OUTPUT
	Outputs are: arrival_timestamps1.latency arrival_timestamps2.latency .. arrival_timestampsN.latency
	
EOF

}

if [[ $1 == "--help" || $# -lt 1 ]]
then
	print_usage
	exit
fi


until [ -z "$1" ]
do
	
	awk '
NR == 1 {
	media = 0;
	start= ($1 "." $2) +0
}
NR>1 {
	tmp = (($1 "." $2) +0 );
	lat = tmp - start;
	media+=lat;
	printf("%.4f\n", lat*1000000);
	start = tmp;
}
END{
	print "\nMedia = " (media/NR)*1000000
}' $1 > $1.latency
	shift

done
