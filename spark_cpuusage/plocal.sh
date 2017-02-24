#!/bin/bash
cat /tmp/pcpu.*.$1.*.out > /tmp/pcpu.totals.out.$$
t_tcpu=0
t_ecpu=0
t_cpuused=0
while IFS=, read pid host tcpu ecpu percent
do
  t_tcpu=$(echo $t_tcpu + $tcpu | bc)
  t_ecpu=$(echo $t_ecpu + $ecpu | bc)
done < /tmp/pcpu.totals.out.$$
t_cpuused=$(echo "scale=2;($t_tcpu / $t_ecpu) * 100" | bc)
echo "Totals,$t_tcpu,$t_ecpu,$t_cpuused" >>/tmp/pcpu.totals.out.$$
cat /tmp/pcpu.totals.out.$$
