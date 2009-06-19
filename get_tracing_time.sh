#!/bin/bash


print_usage() {
	cat - <<EOF
USAGE:
	get_tracing_time.sh tracing.txt <tracing.txt2> ... <tracing.txt3>

KNOWN BUGS:
	It doesnt handle counter overflow

EOF
}

if [[ $1 == "--help" || $# -lt 1 ]]
then
	print_usage
	exit
fi

	
file=$(mktemp)
until [ -z "$1" ]
do
	echo $1 ":"

	(head -10 $1; tail -2 $1 ) > $file
	awk '
	BEGIN{
		OFMT="%.6f"
		CONVFMT=OFMT
		first=0
	}	
	$1 !~ /^#/ {
		if(first==0){
			first=1
			timestamp_start=$3 +0
			print "Start: " timestamp_start
		}
		timestamp_end=$3 +0
	}
	END{
		print "End: " timestamp_end
		print "Total tracing time: " timestamp_end-timestamp_start
	}' $file
	echo ""
	rm $file
	shift
done

