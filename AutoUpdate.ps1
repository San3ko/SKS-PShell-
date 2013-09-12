# 1c support updater script
# by Ivan Tyurin
# winny.ru 2013
#prepare
0 > C:\temp\update\end.ini	#nulling signal-file
$marker = 1
#parameters
$exe = "C:\Users\Ivan\Desktop\iperf.exe"	#path to exe
$arguments = "-c 192.0.0.0"	#parameters
$dir = "C:\temp\update"	#working directory
#cheking files
$checkdir = Test-Path $dir
$check1 = Test-Path $dir\pid.ini
$check2 = Test-Path $dir\update.log
$check3 = Test-Path $dir\end.ini
echo "$check1 $check2 $check3"
if ($checkdir) {} else {
	New-Item $dir -type directory}
if ($check1) {} else {
	New-Item $dir\pid.ini -type file}
if ($check2) {} else {
	New-Item $dir\update.log -type file}
if ($check3) {} else {
	New-Item $dir\end.ini -type file}
#script
$app = start-process $exe $arguments -PassThru
$app = Start-Process cmd -PassThru	#start programm
$date = date	#get date
"$date start update" >> $dir\update.log	#create log-entry
$app.Id > $dir\PID.ini	#create PID entry
$request = Get-Content $dir\end.ini	#marker entry in program
while ($request -eq 0) {
$request = Get-Content $dir\end.ini
echo "sleep 10s"
sleep 300	# 5min
}
sleep 120	# 2min
#killing app
$appid = Get-Content $dir\PID.ini
kill $appid
"$date killing apps" >> $dir\update.log	#create log-entry
0 > C:\temp\update\end.ini
kill $PID
