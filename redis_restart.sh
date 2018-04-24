#!/bin/bash
w_dir=/u01/services/redis-3.0.7
echo \=============restart redis service\==================
echo \*************restart redis-node\*****************
old_pid=`ps aux|grep redis-node|grep -v grep|awk '{print \$2}'`
echo redis-node old pid is: $old_pid
kill -9 $old_pid
$w_dir/redis-node/src/redis-server $w_dir/redis-node/redis.conf
sleep 2
new_pid=`ps aux|grep redis-node|grep -v grep|awk '{print \$2}'`
if [[ $new_pid -eq $old_pid || -z $new_pid ]];then
	echo redis-node restart failed
else
	echo redis-node restart successfully,new pid is: $new_pid
fi
echo \*************redis-node finished\****************
echo \*************restart redis-sentinel\*****************
old_pid=`ps aux|grep redis-sentinel|grep -v grep|awk '{print \$2}'`
echo redis-sentinel old pid is: $old_pid
kill -9 $old_pid
$w_dir/redis-node/src/redis-sentinel $w_dir/redis-node/sentinel.conf
sleep 2
new_pid=`ps aux|grep redis-sentinel|grep -v grep|awk '{print \$2}'`
if [[ $new_pid -eq $old_pid || -z $new_pid ]];then
	echo redis-sentinel restart failed
else
	echo redis-sentinel restart successfully,new pid is: $new_pid
fi
echo \*************redis-sentinel finished\****************
echo \==========redis service restart finished\===============