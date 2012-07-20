#!/bin/bash

# 统计jstat信息，仅使用最后一行
baseDir=$(cd "$(dirname "$0")"; pwd)
for i in `cat $baseDir/testcase`;do
	jstat=`find $i -name jstat.nmon`
	echo `tail -1 $jstat`
done;
