#!/bin/bash
#@20161027 loryu
#set environment variables
work_dir=`pwd`
base_dir=/u01/ccservice
function chk_date(){
	echo `date +%Y%m%d`
}
function chk_time(){
	echo `date +%H:%M:%S`
}
chk_time=`date +%H:%M:%S`
mkdir -p $base_dir/logs
touch $work_dir/logs/$(chk_date).log
echo -e "\033[40;32m $(chk_time) ============start check tomcat==========\033[0m" 2>&1|tee -a $work_dir/$(chk_date).log 
for node_name in `ls $base_dir|grep svr-t7|grep -v test`;do
	old_pid=`ps aux|grep $node_name|grep -v grep|awk '{print \$2}'`
	if [ -z $old_pid ];then
		echo -e "\033[40;31m $(chk_time) $node_name is *NOT* active,start it\033[0m" 2>&1|tee -a $work_dir/$(chk_date).log
		cd $base_dir/$node_name/bin
		./startup.sh
		sleep 20
		new_pid=`ps aux|grep $node_name|grep -v grep|awk '{print \$2}'`
		if [[ $new_pid -eq $old_pid || -z $new_pid ]];then
			echo -e "\033[40;31m $(chk_time) $node_name restart failed,please restart manually\033[0m" 2>&1|tee -a $work_dir/$(chk_date).log
		else
			echo -e "\033[40;31m $(chk_time) $node_name restart finished\033[0m" 2>&1|tee -a $work_dir/$(chk_date).log
		fi
	else
		echo -e "\033[40;31m $(chk_time) $node_name is active\033[0m" 2>&1|tee -a $work_dir/$(chk_date).log
	fi
done
echo -e "\033[40;32m $(chk_time) ============finish check tomcat==========\033[0m" 2>&1|tee -a $work_dir/$(chk_date).log 
