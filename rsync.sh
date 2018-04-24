#!/bin/bash
#@20170424 loryu add multi thread to file backup and copy
work_dir=/u01
function o_date(){
	echo `date +%Y%m%d`
}
function o_time(){
	echo `date +%H:%M:%S`
}
function clean_history(){
	for fname in `ls $bak_dir`;
	do
		fdate=`echo $fname|cut -c-8`
		cdate=`date -d '7 days ago' +%Y%m%d`
		if [[ $fdate -lt $cdate ]];then
			rm -rf $bak_dir/$fname
		fi
	done
}
app_dir=$work_dir/application
bak_dir=$work_dir/applicationbak
log_file=$work_dir/logs/$(o_date).log
tmp_flag=$$.tmp
mkfifo $tmp_flag
exec 6<>$tmp_flag
rm $tmp_flag
tread_amount=2
for ((i=0;i<$tread_amount;i++))
do
	echo
done >&6
if [[ ! -f $log_file ]];then
	touch $log_file
fi
echo $(o_time) ==============start application backup===================== 2>&1|tee -a $log_file
clean_history
cd $app_dir
for i in `ls -l ./|awk '{if ( $1 ~ /^d/ ){print $9}}'`;
do
	read
	{
		echo $(o_time) ======== start backup $i ======== 2>&1|tee -a $log_file
		tar zcvf $(o_date)_$i.tar.gz $i/*
		mv $(o_date)_$i.tar.gz $bak_dir/
		echo $(o_time) ======== $i finish ========= 2>&1|tee -a $log_file
	}&
	echo >&6
done <&6
wait
echo ==============application backup finished================== 2>&1|tee -a $log_file
echo ==============start copy new application=================== 2>&1|tee -a $log_file
cd $app_dir
for i in `ls -l ./|awk '{if ( $1 ~ /^d/ ) {print $9}}'`;
do
	read
	{
		echo $(o_time) *********start $i *********** 2>&1|tee -a $log_file
		rm -rf $i
		mkdir -p $i
		scp -r root@10.45.137.160:/u01/application/$i/* $app_dir/$i/
		chown -R web.web $app_dir/$i
		echo $(o_time) ********** $i finishe ********* 2>&1|tee -a $log_file
	}&
	echo >&6
done <&6
wait
#rm -rf $work_dir/application/*
#scp -r root@10.45.137.160:/u01/application/* $work_dir/application/
echo $(o_time) ==============new application copied======================= 2>&1|tee -a $log_file
