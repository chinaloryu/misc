#!/bin/bash
. /etc/profile
W_dir=/u01/services
echo *********************restart tomcat\***********************
for nn in `ls $W_dir|grep svr-t7`;do
	echo -e "\033[40;32m============restart $nn============\033[0m"
	o_pid=`ps aux|grep $nn|grep -v cronolog|grep -v grep|grep -v \/bin\/sh|awk '{print \$2}'`
	if [ -z $o_pid ];then
		echo -e "\033[40;31m$nn not active\033[0m"
	else
		echo -e "\033[40;32m$nn old pid is:$o_pid\033[0m"
		kill -9 $o_pid
	fi
	cd $W_dir/$nn/bin
	nohup ./startup.sh 2>&1 &
	sleep 15
	n_pid=`ps aux|grep $nn|grep -v cronolog|grep -v grep|grep -v \/bin\/sh|awk '{print \$2}'`
	if [[ $n_pid -eq $o_pid || -z $n_pid ]];then
		echo -e "\033[40;31m$nn restart faild,please restart manually\033[0m"
	else
		echo -e "\033[40;32m$nn restart finished,new pid is:$n_pid"
	fi
	echo -e "\033[40;32m============finish $nn============\033[0m"
done
echo **********************all complete\************************
