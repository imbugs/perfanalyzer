# 统计jstat信息，仅使用最后一行
for i in `cat analyse/testcase`;do
	jstat=`find $i -name jstat.nmon`
	echo `tail -1 $jstat`
done;
