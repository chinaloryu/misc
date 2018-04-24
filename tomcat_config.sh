#!/bin/bash
sed -i 's/8005/8701/g' $1
sed -i 's/8009/8801/g' $1
sed -i '/port\=\"8080\"/a\\t\tmaxKeepAliveRequest\=\"1\"\n\t\tmaxThreads\=\"500\"\n\t\tacceptCount\=\"0\"\n\t\tacceptorThreadCount\=\"8\"\n' $1
sed -i '/port\=\"8080\"/s/8080/9001/g' $1
sed -i '/<\/Host/i\\t\<Context\ docBase\=\"\/u01\/application\/release\"\ path\=\"\"\ reloadable\=\"false\"\ \/\>' $1
