file=`cat analyse/testcase`
for i in $files;do echo $i;tail $i/nmon/jstat* -n 1;done|awk '{print $1}'
