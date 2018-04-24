#!/bin/bash
ps aux |grep java|grep 9005|awk '{print $2}'| xargs kill -9

/bin/sh /letv/services/9005/bin/startup.sh
