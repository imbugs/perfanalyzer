#!/bin/bash

# 统计自定义文件的最大最小耗时结果,计算所有文件符合条件的文件，不进行合并计算
baseDir=$(cd "$(dirname "$0")"; pwd)
for i in `cat $baseDir/testcase`;do
	files=`find $i -name perf*log`; 
	max=0
	min=99999999
	for perf in $files;do
		t=`fgrep TRECV $perf | awk -F"tAvgCost=" '{print $2}' | awk '{print $1}' | fgrep -v "N/A" |sort -n|tail -1` #这行根据需要修改
		h=`fgrep TRECV $perf | awk -F"tAvgCost=" '{print $2}' | awk '{print $1}' | fgrep -v "N/A" |sort -n|head -1` #这行根据需要修改
		echo $t-$h
		if [ `echo "$t > $max" | bc` -eq 1 ];then
			max=$t
		fi
		if [ `echo "$h < $min"|bc` -eq 1 ];then
			min=$h
		fi
	done
	echo $min-$max
done
#fgrep RECV $perf | awk -F"avgCost=" '{print $2}' | awk '{print $1}' | fgrep -v "N/A" |sort -n|tail -1
