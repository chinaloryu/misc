#!/bin/bash
export TOMCAT_OSPID=`netstat -antpu|grep 9003|grep java|awk '{print $7}'`

/bin/kill -9 ${TOMCAT_OSPID%/*}

/bin/sh /letv/services/9003/bin/startup.sh 
# -Djava.awt.headless=true
