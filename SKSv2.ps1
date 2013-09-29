#ver 0.2b
#SK scripts
#Tyurin Ivan
#====PARAMETERS
$dir = "C:\temp\update"
$wdir = "C:\temp\update\$PID"
$exefile = "C:\Users\Ivan\Documents\GitHub\PShell\changer\src\changer.exe"
$arguments = '-dir '+$dir
#====VAR
	$request = 0
	$marker = 1
	$log_step = 0
#====FUNCTIONS
function files_create {
	$checkdir = Test-Path $dir
	$checkwdir = Test-Path $wdir
	if ($checkdir) {} else {
		New-Item $dir -type directory}
	if ($checkwdir) {} else {
		New-Item $wdir -type directory
		New-Item $wdir\pid.ini -type file
		New-Item $wdir\end.ini -type file}
	$check_log = Test-Path $dir\update.log
	$check_l = Test-Path $dir\lastpid.ini
	if ($check_l) {} else {
		New-Item $dir\lastpid.ini -type file}
	if ($check_log) {} else {
		New-Item $dir\update.log -type file}
}
function files_del {
	Remove-Item $wdir -recurse
}
function start_exe {
	0 > $wdir\end.ini
	$PID > $dir\lastpid.ini
	$dir >> $dir\lastpid.ini
	$log_step = 1
	log_entry
	$app = start-process $exefile $arguments -PassThru
	$app.Id > $wdir\PID.ini
}
function wait_marker {
	while ($request -eq 0) {
	$request = Get-Content $wdir\end.ini
	echo "sleep 10s"
	sleep 10			#in seconds. set other if need
	}
	sleep 5				#in seconds. set other if need
}
function kill_exe {
	$log_step = 2
	log_entry
	$appid = Get-Content $wdir\PID.ini
	kill $appid
	0 > $wdir\end.ini
	files_del
	#Read-Host "Нажмите Enter"
	kill $PID
}
function log_entry {
	$date = date
	switch ($log_step) 
    { 
        0 {
		"=============== $PID" >> $dir\update.log
		"$date | Starting script" >> $dir\update.log} 
		1 {
		"$date | Starting exe file" >> $dir\update.log}
		2 {
		"$date | Killing exe by PID" >> $dir\update.log}
        default {"The color could not be determined."}
    }
}
#==================SCRIPT
files_create
log_entry
start_exe
wait_marker
kill_exe
