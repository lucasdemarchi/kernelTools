#!/bin/bash


print_usage() {
	cat - <<EOF
USAGE:
	get_process_time.sh sched_debug1 <sched_debug2> ... <sched_debugN>

KNOWN BUGS:
	It doesnt handle counter overflow

EOF
}

if [[ $1 == "--help" || $# -lt 1 ]]
then
	print_usage
	exit
fi


until [ -z "$1" ]
do
	echo $1
	cat $1 | grep Date | awk 'BEGIN{ init=0; v=0 }{ init++; if(init == 2){ v=$2 - v; print v; init=0} else v=$2}'
	shift
done

