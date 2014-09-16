#!/bin/bash

# 统计自定义文件的最大TPS结果,并将结果按测试场景分组求和
baseDir=$(cd "$(dirname "$0")"; pwd)

#在文件中查找与指定时间最接近的时间,误差范围在10s内
function recent() {
	dateStr=$1
	fileName=$2

	diff=1
	maxDiff=10
	curStr=$dateStr
	recentTime=`fgrep "$dateStr" $fileName|cut -d',' -f1`
	flag="-1"

	while [[ "$recentTime" == "" && "$diff" -lt "$maxDiff" ]];do
		dv=`date -d "$dateStr" +%s`
		dv=$(($dv + $diff));
		curStr=`date -d @$dv "+%Y-%m-%d %H:%M:%S"`
		recentTime=`fgrep "$curStr" $fileName|cut -d',' -f1`
		if [ "$flag" == "add" ]; then
			diff=$((1 - $diff));
			flag="-1"
		else
			diff=$((0 - $diff));
			flag="add"
		fi
	done

	if [ "$recentTime" != "" ];then
		echo $curStr
	fi
}

function divide() {
	a=$1
	b=$2
	if [ `echo "$b == 0" | bc` -eq 1 ];then
		echo "0"
	else
		echo `echo "$a / $b" | bc`
	fi
}
#rt=`recent "2012-07-10 20:39:04" ~/zqueue/bin/201207102040-M4-mtest/confregdata4.test.imbugs.com/perf-test-result.log`
#echo $rt
