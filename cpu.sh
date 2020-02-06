#!/bin/bash
PATHS="/"
HOSTNAME=$(hostname)
CRITICAL=98
WARNING=90
CRITICALMail="praveenkumar.edulakanti@gmail.com"
MAILWAR="praveenkumar.edulakanti@gmail.com"
mkdir -p /var/log/cputilhistory
LOGFILE=/var/log/cputilhistory/cpusage-`date +%h%d%y`.log
touch $LOGFILE
for path in $PATHS
do
CPULOAD=`top -b -n 2 d1 | grep "Cpu(s)" | tail -n1 | awk '{print $2}' | awk -F. '{print $2}'`
if [ -n $WARNING -a -n $CRITICAL ]; then
if [ "$CPULOAD" -ge "$WARNING" -a "$CPULOAD" -lt "$CRITICAL" ]; then
echo "`date "+%F %H:%M:%S"` WARNING - $CPULOAD on Host $HOSTNAME" >> $LOGFILE
echo "Warning Cpuload $CPULOAD Host is $HOSTNAME" | mail -s "CPULOAD is Warning" $MAILWAR
exit 1
elif [ "$CPULOAD" -ge "$CRITICAL" ]; then
echo "`date "+%F %H:%M:%S"` CRITICAL - $CPULOAD on Host $HOSTNAME" >> $LOGFILE
echo "CRITICAL Cpuload $CPULOAD Host is $HOSTNAME" | mail -s "CPULOAD is CRITICAL" $CRITICALMail
exit 2
else
echo "`date "+%F %H:%M:%S"` OK  - $CPULOAD on Host $HOSTNAME" >> $LOGFILE
exit 0
fi
fi
done
