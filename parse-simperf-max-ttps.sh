#!/bin/bash
# 将同一时刻的tTps求和，再找出最大的值,有针对时间的处理,使用fgrep处理，文件太大时速度会很慢
baseDir=$(cd "$(dirname "$0")"; pwd)
source $baseDir/functions.sh

date="2012-09-07" #需要统计的时间段
file="perf*log";

for i in `cat $baseDir/testcase`;do
	files=`find $i -name $file`; 

	if [ "$files" == "" ];then
		echo "no $file files";
		exit;
	fi
	tscount=0
	maxtsfile=""
	for perf in $files;do
		tmp=`fgrep $date $perf | wc -l`
		if [ "$tmp" -gt "$tscount" ]; then
			tscount=$tmp
			maxtsfile=$perf
		fi
	done

	maxCount=0
	for sedTime in `fgrep $date $maxtsfile | cut -d',' -f1 | sed 's/ /=/'`;do
		t=`echo $sedTime | sed 's/=/ /'`
		tmp=0
		for perf in $files; do
			rt=`recent "$t" $perf`
			if [ "$rt" == "" ];then
				continue
			fi
			val=`fgrep "$rt" $perf -A1 | fgrep TRECV | awk -F"tTps=" '{print $2}' | awk '{print $1}'| fgrep -v "N/A"`
			if [ "$val" == "" ];then
				continue
			fi

			tmp=$(($tmp + $val))
		done
		if [ `echo "$tmp > $maxCount"|bc` -eq 1 ]; then
			maxCount=$tmp
		fi
	done
	echo $maxCount
done
