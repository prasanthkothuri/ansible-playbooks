#!/bin/bash
hostname=$(uname -n)
for i in $(echo $1 | sed "s/,/ /g")
do
while ps -p $i > /dev/null
do
tcpu=$(echo "scale=2;$(awk '{ print $14+$15+$16+$17 }' /proc/$i/stat) / 100" | bc)
ecpu=$(echo $(awk '{print $1}' /proc/uptime) - $(echo "scale=2;$(awk '{print $22}' /proc/$i/stat) / 100" | bc) | bc)
used=$(echo "scale=5; 100 * ($tcpu/$ecpu)"|bc)
echo "$i,$hostname,$tcpu,$ecpu,$used" > /tmp/pcpu.$hostname.$2.$i.out
sleep 1
done &
done

for job in `jobs -p`
do
    wait $job
done

