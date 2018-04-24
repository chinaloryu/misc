#!/bin/sed -f
/^<\/Context/i\<Manager\ className\=\"com.orangefunction.tomcat.redissessions.RedisSessionManager\"\n\thost\=\"10.173.32.9:6379\"\n\tmaxInactiveInterval\=\"60\"\n\tsentinelMaster\=\"mymaster\"\n\tsentinels\=\"10.173.32.9:26379,10.173.32.12:26379,10.172.32.13:26379\" \/\>
