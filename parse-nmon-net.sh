#!/bin/bash

# 统计网络使用，网络>1M列入统计，I/O
baseDir=$(cd "$(dirname "$0")"; pwd)
for i in `cat $baseDir/testcase`;do
	nmon=`find $i -name zqueue*nmon`
	in=`fgrep NET $nmon | fgrep -v NETPAC |fgrep -v Network| cut -d',' -f5`
	insum=0
	incount=0
	for c in $in;do
		if [ `echo "$c > 1000" | bc` -eq 1 ];then
			insum=`echo "$c + $insum"|bc`;
			incount=$(($incount+1))
		fi
	done;
	inavg=`echo "$insum / $incount" | bc`

	out=`fgrep NET $nmon | fgrep -v NETPAC |fgrep -v Network| cut -d',' -f8`
	osum=0
	ocount=0
	for c in $out;do
		if [ `echo "$c > 1000" | bc` -eq 1 ];then
			osum=`echo "$c + $osum"|bc`;
			ocount=$(($ocount+1))
		fi
	done;
	oavg=`echo "$osum / $ocount" | bc`
	echo $inavg/$oavg
done;

