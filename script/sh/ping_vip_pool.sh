IpPrefix=10.8.16

for i in {50..63}; do   if ping -c 1 -W 1 $IpPrefix.$i > /dev/null; then     echo "$IpPrefix.$i :white_check_mark: Success";   else     echo "$IpPrefix.$i :x: Fail";   fi; done
#for i in {1..48}; do   if ping -c 1 -W 1 10.5.251.$i > /dev/null; then     echo "10.5.251.$i :white_check_mark: Success";   else     echo "10.5.251.$i :x: Fail";   fi; done

