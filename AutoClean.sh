#!/bin/bash
#@20161118 loryu
srv_dir=/u01/services/
function operdate(){
	echo `date +%Y-%m-%d`
}
function opertime(){
	echo `date +%H:%M:%S`
}
function cleanup(){
	cur_year=`date +%Y`
	cur_month=`date +%m`
	tmp_fifo=$$.tmp
	mkfifo $tmp_fifo
	exec 5<>$tmp_fifo
	rm $tmp_fifo
	thread_amount=3
	for ((i=0;i<$thread_amount;i++))
	do
		for fn in `ls $1|grep svr-t7`
		do
			read
			{
				fc_month=`ls $1/$fn/logs|grep $cur_year|awk -F'.' '{print \$2}'|awk -F'-' '{print \$2}'`
				echo > $1/$fn/logs/catalina.out
				if [[ $cur_month -gt $(expr $fc_month + 1 ) ]];then
					rm -rf $1/$fn/logs/*.$cur_year-$fc_month-*
				else
					echo $fn cleanup done
				fi
				echo >&5
			}&
		done <&5
		wait
	done
	exec 5>&-	
}

#start script
echo ======tomcat log auto clean start\=======
echo input tomcat service path[by default,set to /u01/services]:
read -t 10 t_path

if [[ -z $t_path ]];then
	t_path=$srv_dir
else
	t_path=$t_path
fi
if [[ -d $t_path ]];then
	echo use tomcat path $t_path
	cleanup $t_path 2>&1|tee -a /tmp/$(operdate).log
else
	echo tomcat path $t_path does not exist
fi
echo =======tomcat log clean finish\==========

