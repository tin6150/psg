#!/bin/bash


# testing various ideas in setting TZ

TZ_LIST=$(  find /usr/share/zoneinfo -type f -exec tail -1 {} \; )
for TZ in $TZ_LIST; do
        echo $TZ
        date -d "TZ=\"$TZ\"  2016-02-29 13:45"
done



