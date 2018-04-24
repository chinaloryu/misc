#!/bin/bash
ps aux |grep java|grep 9004|awk '{print $2}'| xargs kill -9

/bin/sh /letv/services/9004/bin/startup.sh
