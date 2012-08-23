#!/bin/bash
FILE='msgbroker_*nmon';
THRESHOLD=10;

ColIdx=3;

# 统计网络使用，网络>1M列入统计，I/O
baseDir=$(cd "$(dirname "$0")"; pwd)
source $baseDir/functions.sh
for i in `cat $baseDir/testcase`;do
	nmon=`find $i -name $FILE`

	rall=`fgrep DISKREAD $nmon | fgrep -v Read| cut -d',' -f3`
	rsum=0
	rcount=0
	for c in $rall;do
		if [ `echo "$c > $THRESHOLD" | bc` -eq 1 ];then
			rsum=`echo "$c + $rsum"|bc`;
			rcount=$(($rcount+1))
		fi
	done;
	ravg=`divide $rsum $rcount`
	
	wall=`fgrep DISKWRITE $nmon | fgrep -v Write| cut -d',' -f3`
	wsum=0
	wcount=0
	for c in $wall;do
		if [ `echo "$c > $THRESHOLD" | bc` -eq 1 ];then
			wsum=`echo "$c + $wsum"|bc`;
			wcount=$(($wcount+1))
		fi
	done;
	wavg=`divide $wsum $wcount`
	
	ball=`fgrep DISKBUSY $nmon | fgrep -v Busy| cut -d',' -f3`
	bsum=0
	bcount=0
	for c in $ball;do
		if [ `echo "$c > $THRESHOLD" | bc` -eq 1 ];then
			bsum=`echo "$c + $bsum"|bc`;
			bcount=$(($bcount+1))
		fi
	done;
	bavg=`divide $bsum $bcount`
	echo $ravg/$wavg/$bavg
done;

