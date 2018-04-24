#!/bin/bash
work_dir=/u01/applications/git/release
cd $work_dir
git pull
git rev-parse HEAD > version.txt
cd ..
rm -rf release.tar.gz 
tar zcvf release.tar.gz --exclude=\.* release
rm -rf release.zip
zip -x "*\/\.*" -x "\.*" -r release.zip release
