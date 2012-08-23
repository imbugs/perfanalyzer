该工具用于分析各种性能日志

分布式测试目前的结构是一个Server多个Client，测试目录结构：
tesetcase-result-1
├── domain1.imbugs.com #Client1
│   └── perf-test-result.log #Client1性能日志
├── domain2.imbugs.com #Client2
│   └── perf-test-result.log #Client2性能日志
├── domain3.imbugs.com
│   └── perf-test-result.log
├── domain4.imbugs.com
│   └── perf-test-result.log
└── nmon #Server端监控日志
    ├── jstat.nmon
    └── zqueue_120711_2020.nmon

监控命令如下：
jstat.log, jstat -gcutil -t $PID 5000
xxxx.nmon, nmon -f -s 5 -c 100000

howlong.sh，从jstat中获取JAVA进行运行时长
parse-jstat.sh，获取jstat中的最后一行信息，做为采样信息
parse-nmon-cpu.sh，从nmon日志中分析平均CPU占用率，采用CPU>5%的数据
parse-nmon-disk.sh，从nmon日志中分析DISK使用情况，读/写/繁忙程度，计算平均值
parse-nmon-disk-max.sh, 从nmon日志中分析DISK使用情况，读/写/繁忙程度，只取最大值
parse-nmon-net.sh，从nmon日志中分析网络使用情况，输入/输出
parse-simperf-avgcost.sh，从simperf日志中分析平均耗时信息(avgcost)，会对所有Client的avgcost进行平均计算
parse-simperf-max-min-tavgcost.sh，从simperf日志中分析最大最小的耗时信息(tavgcost)，查找所有Client的日志，查找出最大与最小的tavgcost
parse-simperf-max-ttps.sh，将同一时刻的tTps求和，再找出最大的值,有针对时间的处理,使用fgrep处理，文件太大时速度会很慢
parse-simperf-count-max-ttps.sh，从simperf日志中计算所有Client的最大瞬时TPS(tTps)之和，会查找所有Client日志中最大的tTps，并进行相加
parse-simperf-json.pl，新版本simperf生成json的结果文件，针对json文件进行解析统计的perl脚本
guide.md，说明文档
testcase，存放需要统计的用例结果目录，例如：tesetcase-result-1，所有脚本会按此文件包含的内容进行统计
