#!/bin/bash


print_usage() {
	cat - <<EOF
USAGE:
	get_nswitches.sh sched_debug1 <sched_debug2> ... <sched_debugN>

KNOWN BUGS:
	It doesnt handle counter overflow

LIMITATIONS:
	The number of arguments is the number of enabled CPUs, and the given
	sched_debug files are in crescent order

EOF
}

if [[ $1 == "--help" || $# -lt 1 ]]
then
	print_usage
	exit 0
fi

NCPUS=$#
ncpus_enabled=1
until [ -z "$1" ]
do
	filename=$1
	echo -e "$filename:"
	awk -v nproc=$ncpus_enabled '
BEGIN{
	for (j=0; j < nproc; j++)
		nswitches[j]=0
}
/^cpu#[0-9]/{
	scpu=$1
	sub("cpu#","",scpu)
	cpu = strtonum(scpu)
	next
}

$1 ~ /\.nr_switches/{
	if(nswitches[cpu] == 0 ){
		nswitches[cpu] = $3;
	}
	else{
		nswitches[cpu] = $3 - nswitches[cpu]
		print "CPU: " cpu ", n_switches: " nswitches[cpu]
	}
}
END{
	sum = 0
	for (j=0; j < nproc; j++)
		sum += nswitches[j]
	print "Sum: " sum
}
' $filename
	echo ""
	shift
	let ncpus_enabled++
done
