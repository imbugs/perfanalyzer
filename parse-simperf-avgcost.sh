# 统计自定义文件的平均耗时结果,按组进行平均计算,采样时的平均值是不排序的，直接采用文件最后一行
for i in `cat analyse/testcase`;do
	files=`find $i -name perf*log`; 
	sum=0
	count=0
	for perf in $files;do
		#echo "fgrep RECV $perf |fgrep -v ORECV| awk -F"avgCost=" '{print $2}' | awk '{print $1}' | fgrep -v "N/A" |tail -1"
		val=`fgrep RECV $perf |fgrep -v ORECV| awk -F"avgCost=" '{print $2}' | awk '{print $1}' | fgrep -v "N/A" |tail -1` #这行根据需要修改
		if [ "$val" == "" ];then
			continue
		fi
		sum=$(($sum + $val))
		count=$(($count+1))
	done
	avg=`echo "$sum / $count" | bc`
	echo $avg
done

