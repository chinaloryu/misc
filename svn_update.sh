#!/bin/bash
svn_dir=/u01/applications/2016
svn_major=r8
cd $svn_dir/$svn_major
svn update
rev=`svn info|egrep '(Last\ Changed\ Rev|最后修改的版本)'|cut -d : -f 2|cut -c2-`
echo $svn_major Rev\:$rev > release/version.txt
rm -rf release.tar.gz 
tar zcvf release.tar.gz --exclude=\.* release
rm -rf release.zip
zip -x "*\/\.*" -x "\.*" -r release.zip release
