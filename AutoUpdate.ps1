# 1c support updater script
# by Ivan Tyurin
# winny.ru 2013
#prepare
0 > C:\temp\update\end.ini	#nulling signal-file
$marker = 1
#parameters
$exefile = "C:\Users\Ivan\Desktop\iperf.exe"
$arguments = "-c 192.168.1.35"
#script
$app = start-process $exefile $arguments -PassThru
$app = Start-Process cmd -PassThru	#start programm
$date = date	#get date
"$date start update" >> C:\temp\update\update.log	#create log-entry
$app.Id > C:\temp\update\PID.ini	#create PID entry
$request = Get-Content C:\temp\update\end.ini	#marker entry in program
while ($request -eq 0) {
$request = Get-Content C:\temp\update\end.ini
echo "sleep 10s"
sleep 300	# 5min
}
sleep 120	# 2min
#killing app
$appid = Get-Content C:\temp\update\PID.ini
kill $appid
"$date killing apps" >> C:\temp\update\update.log	#create log-entry
0 > C:\temp\update\end.ini
kill $PID