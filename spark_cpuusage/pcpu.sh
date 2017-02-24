#!/bin/bash
hostname=$(uname -n)
SERVER=hmetrics.cern.ch
PORT=2003
for i in $(echo $1 | sed "s/,/ /g")
do
while ps -p $i > /dev/null
do
#eid=$(ps aux | grep $i | grep -v grep | awk '{ print $25 }')
eid=$(ps aux | grep $i | grep -v grep | awk '{for (i = 1; i <= NF; i++) { if ( $i == "--executor-id" ) { print $(i+1) } }}')
tcpu=$(echo "scale=2;$(awk '{ print $14+$15+$16+$17 }' /proc/$i/stat) / 100" | bc)
ecpu=$(echo $(awk '{print $1}' /proc/uptime) - $(echo "scale=2;$(awk '{print $22}' /proc/$i/stat) / 100" | bc) | bc)
used=$(echo "scale=5; 100 * ($tcpu/$ecpu)"|bc)
#echo "$i,$hostname,$tcpu,$ecpu,$used" > /tmp/pcpu.$hostname.$2.$i.out
echo "$2.$eid.executor.cpu.ctime $tcpu `date +%s`" | nc ${SERVER} ${PORT}
echo "$2.$eid.executor.cpu.etime $ecpu `date +%s`" | nc ${SERVER} ${PORT}
sleep 1
done &
done

for job in `jobs -p`
do
    wait $job
done

