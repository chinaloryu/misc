#!/bin/bash
app_dir=/letv/app
work_dir=/letv/services
log_dir=/letv/update_log
get_date(){
	date +%Y%m%d
}
update_progress(){
	echo "===== backup current application =====" 2>&1|tee -a $log_dir/$(get_date).log
	cd $app_dir
	cp -r release release_$(get_date)
	if [[  $? -eq 0 ]];then
		echo backup finished 2>&1|tee -a $log_dir/$(get_date).log
		echo "===== start extract new application =====" 2>&1|tee -a $log_dir/$(get_date).log
		rm -rf $app_dir/release
		mkdir -p $(get_date)
		cd $app_dir/$(get_date)
		tar xvf ../release.tar.gz
		echo "===== extract new application finished =====" 2>&1|tee -a $log_dir/$(get_date).log
		echo "===== copy files to new application =====" 2>&1|tee -a $log_dir/$(get_date).log
		cp -r $app_dir/release_$(get_date)/customize $app_dir/$(get_date)/release/
		cp -r $app_dir/release_$(get_date)/WEB-INF/classes/com/cloudcc/core $app_dir/$(get_date)/release/WEB-INF/classes/cloudcc/
		\cp -rf $app_dir/release_$(get_date)/WEB-INF/classes/com/g3cloud/dbu/conf/{ccnode,cayenne.xml} $app_dir/$(get_date)/release/WEB-INF/classes/com/g3cloud/dbu/conf/
		\cp -rf $app_dir/release_$(get_date)/WEB-INF/classes/{cloudcc.properties,licence,log4j.properties} $app_dir/$(get_date)/release/WEB-INF/classes/
		\cp -rf $app_dir/release_$(get_date)/login.jsp $app_dir/$(get_date)/release/
		sed -i '/session-timeout/s/120/7200/g' $app_dir/$(get_date)/release/WEB-INF/web.xml
		mv $app_dir/$(get_date)/release $app_dir/
		echo "===== new application progress finished =====" 2>&1|tee -a $log_dir/$(get_date).log
		echo "===== start tomcat services =====" 2>&1|tee -a $log_dir/$(get_date).log
		cd $work_dir
		./tomcat_restart.sh
		echo "===== tomcat start finished =====" 2>&1|tee -a $log_dir/$(get_date).log
	else
		echo backup failed,please check out disk avaliable space or user privilege. 2>&1|tee -a $log_dir/$(get_date).log
	fi
}
if [[ ! -d $log_dir ]];then
	mkdir -p $log_dir
fi
echo "***** start update progress *****" 2>&1|tee -a $log_dir/$(get_date).log
tomcat_ins=`pgrep java|wc -l`
if [[ $tomcat_ins -gt 0 ]];then
	echo "===== stop tomcat services =====" 2>&1|tee -a $log_dir/$(get_date).log
	pgrep java|xargs kill -9
	if [[ $? -eq 0 ]];then
		echo "===== stop tomcat services =====" 2>&1|tee -a $log_dir/$(get_date).log
		update_progress
	else
		echo kill tomcat faild,please shutdown tomcat manually and redo update progress. 2>&1|tee -a $log_dir/$(get_date).log
	fi
else
	update_progress
fi
echo "***** finished update progress *****" 2>&1|tee -a $log_dir/$(get_date).log