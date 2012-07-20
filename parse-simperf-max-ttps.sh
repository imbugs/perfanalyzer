#!/bin/bash

# 统计自定义文件的最大TPS结果,并将结果按测试场景分组求和
baseDir=$(cd "$(dirname "$0")"; pwd)
for i in `cat $baseDir/testcase`;do
	files=`find $i -name perf*log`; 
	sum=0;
	for perf in $files;do
		num=`fgrep TRECV $perf | awk -F"tTps=" '{print $2}' | awk '{print $1}' | fgrep -v "N/A" |sort -n|tail -1` #这行根据需要修改
		sum=$(($num + $sum));
	done
	echo $sum
done
#	tTps=`fgrep TSEND $i | awk -F"tTps=" '{print $2}' | awk '{print $1}' | fgrep -v "N/A" |sort -n|tail -1`
#	tFail=`fgrep TSEND $i | awk -F"tFail=" '{print $2}' | awk -F] '{print $1}' | fgrep -v "N/A" |sort -n|tail -1`
#	rTps=`fgrep TRECV $i | awk -F"tTps=" '{print $2}' | awk '{print $1}' | fgrep -v "N/A" |sort -n|tail -1`
