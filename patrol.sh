#!/bin/bash
#@20161102 loryu
function execute_date(){
	echo `date +%Y%m%d`
}
function execute_script(){
	ansible $1 -m shell -a '/tmp/system_report.sh'
}
function fetch_result(){
	ansible $1 -m fetch -a "src=/u01/logs/$(execute_date).log dest=/tmp/$1/"
}
node_amount=`sed -n '/^\[cloud.*\]$/p' /etc/ansible/hosts|cut -c2-$NF|rev|cut -c2-|rev|wc -l`
for ((n=0;n<$node_amount;n++));do
	node_cloud[$n]=`sed -n '/^\[cloud.*\]$/p' /etc/ansible/hosts|cut -c2-$NF|rev|cut -c2-|rev|awk "NR==$n {print}"`
done
tmp_flag=$$.tmp
mkfifo $tmp_flag
exec 6<>$tmp_flag
rm $tmp_flag
tread_amount=5
for ((i=0;i<$tread_amount;i++))
do
	echo
done >&6
echo *********************start execute\********************* 2>&1|tee -a /tmp/$(execute_date).log
echo node read from ansible hosts 2>&1|tee -a /tmp/$(execute_date).log
for ((t=1;t<=$node_amount;t++))
do
	read
	{
		execute_script ${node_cloud[$t]} 2>&1|tee -a /tmp/$(execute_date).log
		echo ${node_cloud[$t]} done
	}&
	echo >&6
done <&6
wait
echo *********************execute finished\********************* 2>&1|tee -a /tmp/$(execute_date).log
sleep 5
echo *********************start fetch\********************* 2>&1|tee -a /tmp/$(execute_date).log
echo node read from ansible hosts 2>&1|tee -a /tmp/$(execute_date).log
for ((t=1;t<=$node_amount;t++));
do
	read 
	{
		echo fetch ${node_cloud[$t]} 2>&1|tee -a /tmp/$(execute_date).log
		fetch_result ${node_cloud[$t]} 2>&1|tee -a /tmp/$(execute_date).log
		echo result fetched,save to /tmp/${node_cloud[$t]}/server.external.ip.address/u01/logs/$(execute_date).log
		echo >&6
	}&
done <&6
wait
exec 6>&-
echo *********************fetch finished\********************* 2>&1|tee -a /tmp/$(execute_date).log
