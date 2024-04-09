#########################################
#思路：通过/proc/stat获取cpu使用信息，根据cpu使用数值计算：
#user   - CPU 花在用户模式的时间，即运行应用程序花费的时间
#nice   - CPU 花在 nice 值大于一般值 0 (即有较低优先级别) 进程的时间。
#system - CPU 花在系统模式即在内核空间 (kernel space) 的时间，即在运行内核工作的时间
#idle   - CPU 闲置的时间，其值一定为 /proc/uptime 中第二个项目乘 USER_HZ
#iowait - CPU 花在等候输入/输出的时间，Linux 2.5.41 开始才开始支援
#irq    - CPU 花在处理硬件中断 (hardware interrupt) 的时间，Linux 2.6.0-test4 开始支持
#softirq- CPU 花在处理 softirq 软件中断的时间，Linux 2.6.0-test4 开始支持
#steal_time  - 在虚拟环境下 CPU 花在处理其他作业系统的时间，Linux 2.6.11 开始支持（虚拟环境下出现，本例中无此项）
#guest  - 在 Linux 内核控制下 CPU 为 guest 作业系统运行虚拟 CPU 的时间，Linux 2.6.24 开始支持（虚拟环境下出现，本例中无此项）
#CPU总时间：total=user+nice+system+idle+iowait+irq＋softirq+steal_time+guest
#CPU繁忙时间：time=user+nice+system+iowait+irq＋softirq+steal_time+guest
#间隔1秒钟2次获取CPU总时间：total1、total2
#和CPU繁忙时间：time1、time2
#CPU使用率=(time2-time1)/(total2-total1)
#
#interval,获取cpu 使用的时间间隔；
#########################################


showhelp()
{
echo '帮助: '
echo 'OPTIONS:'
echo '-a : 每个CPU使用率'
echo '-t : 总体使用率'
echo '数字 :某一个CPU使用率'
}


get_cpu_rate()
{
#interval,获取cpu 使用的时间间隔；  
interval=1
#获取cpu数目
cpu_num=`cat /proc/stat | grep cpu[0-9] -c`


#cpu等待时间数组
start_idle=()
#cpu使用总时间数组
start_total=()
#cpu使用率数组
cpu_rate=()
#计算初始每个cpu使用数据
    for((i=0;i<${cpu_num};i++))
    {
        start=$(cat /proc/stat | grep "cpu$i" | awk '{print $2" "$3" "$4" "$5" "$6" "$7" "$8}')
        start_idle[$i]=$(echo ${start} | awk '{print $4}')
        start_total[$i]=$(echo ${start} | awk '{printf "%.f",$1+$2+$3+$4+$5+$6+$7}')
    }
 #计算初始总cpu使用数据 
    start=$(cat /proc/stat | grep "cpu " | awk '{print $2" "$3" "$4" "$5" "$6" "$7" "$8}')
    start_idle[${cpu_num}]=$(echo ${start} | awk '{print $4}')
    start_total[${cpu_num}]=$(echo ${start} | awk '{printf "%.f",$1+$2+$3+$4+$5+$6+$7}')
#interval时间后
    sleep ${interval}
#计算时间间隔后每个cpu使用数据,并根据数据计算出每个CPU使用率   
    for((i=0;i<${cpu_num};i++))
    {
        end=$(cat /proc/stat | grep "cpu$i" | awk '{print $2" "$3" "$4" "$5" "$6" "$7" "$8}')
        end_idle=$(echo ${end} | awk '{print $4}')
        end_total=$(echo ${end} | awk '{printf "%.f",$1+$2+$3+$4+$5+$6+$7}')
        idle=`expr ${end_idle} - ${start_idle[$i]}`
        total=`expr ${end_total} - ${start_total[$i]}`
cpu_usage=`expr ${idle} \* 100 / ${total}`
        cpu_rate[$i]=`expr 100 - ${cpu_usage}`
       # echo cpu$i:${cpu_rate[$i]}
    }
 #计算时间间隔后总cpu使用数据，并根据数据计算出计算机所有CPU的总体使用率  
    end=$(cat /proc/stat | grep "cpu " | awk '{print $2" "$3" "$4" "$5" "$6" "$7" "$8}')
    end_idle=$(echo ${end} | awk '{print $4}')
    end_total=$(echo ${end} | awk '{printf "%.f",$1+$2+$3+$4+$5+$6+$7}')
    idle=`expr ${end_idle} - ${start_idle[$i]}`
    total=`expr ${end_total} - ${start_total[$i]}`
    cpu_usage=`expr  ${idle} \* 100 / ${total}`
    cpu_rate[${cpu_num}]=`expr 100 - ${cpu_usage}`
   # echo "${cpu_rate[${cpu_num}]}" #返回总体使用率
 
 while [ $1 ]; do
	case $1 in
		'-a'  )
for((i=0;i<${cpu_num};i++))
{
echo "cpu$i:${cpu_rate[$i]}"
}
exit
;;
*[0-9]* )
echo "cpu$1:${cpu_rate[$1]}"
exit
;;
'-t' )
echo "CPU负载:${cpu_rate[${cpu_num}]}"
exit
;;  
* )
showhelp
exit
;;
esac
shift
done   
}


while true; do 
   #echo $(get_cpu_rate)
   #read var <<< $(get_cpu_rate)
  # echo "CPU rate:" $var
  read var <<< $(get_cpu_rate -t)
  echo $var% > /tmp/oled/cpustat
done
