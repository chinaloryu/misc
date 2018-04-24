#!/bin/bash
ps aux |grep java|grep 9002|awk '{print $2}'| xargs kill -9

/bin/sh /letv/services/9002/bin/startup.sh
