#!/bin/bash
for i in 9001 9002 9003;do
	sed -i '/^#\ OS\ specific/iJAVA_OPTS\=\"-server\ -XX\:PermSize\=512m\ -XX\:MaxPermSize\=512m\ -Xms4608m\ -Xmx4608m\"' $1/svr-t7-$i/bin/catalina.sh
done
