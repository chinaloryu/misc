#!/bin/bash
ps aux |grep java|grep 9003|awk '{print $2}'| xargs kill -9

/bin/sh /letv/services/9003/bin/startup.sh
