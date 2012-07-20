#!/bin/bash

# 统计CPU使用率，CPU>5%列入统计范围
baseDir=$(cd "$(dirname "$0")"; pwd)
for i in `cat $baseDir/testcase`;do
	nmon=`find $i -name zqueue*nmon`
	idel=`fgrep CPU_ALL $nmon |fgrep -v CPUs | cut -d',' -f6`
	cpu=0
	count=0
	for c in $idel;do
		if [ `echo "$c < 96" | bc` -eq 1 ];then
			cpu=`echo "$c + $cpu"|bc`;
			count=$(($count+1))
		fi
	done;
	AVG=`echo "100 - $cpu / $count" | bc`
	echo $AVG
done;

