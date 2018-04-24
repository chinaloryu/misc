#!/bin/bash
ps aux |grep java|grep 9001|awk '{print $2}'| xargs kill -9

/bin/sh /letv/services/9001/bin/startup.sh
