#ver 2.9.4
#SK scripts
#Tyurin Ivan
#====PARAMETERS
$dir = "C:\temp\update"
$wdir = "C:\temp\update\$PID"
$exefile = "cmd.exe"
$arguments = '-dir '+$dir+' -pid '+$PID
$exit_time = 30
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
		New-Item $wdir\end.ini -type file
		New-Item $wdir\temp.log -type file}
	$check_log = Test-Path $dir\update.log
	if ($check_log) {} else {
		New-Item $dir\update.log -type file}
}
function files_del {
	Remove-Item $wdir -recurse
}
function start_exe {
	0 > $wdir\end.ini
	$app = start-process $exefile $arguments -PassThru
	$app.Id > $wdir\PID.ini
	$log_step = 1
	log_entry
}
function wait_marker {
	$est_time = 0
	while ($request -eq 0) {
		$request = Get-Content $wdir\end.ini
		echo "sleep 10s"
		sleep 10			#in seconds. set other if need
		if ($est_time -ge $exit_time) {
			$request = 1
			$date = date
			"$date"+" | "+$PID+" | !!! Stopping by time after "+$est_time+"s" >> $wdir\temp.log}
		$est_time = ($est_time + 10)
	}
	sleep 5				#in seconds. set other if need
	$date = date
	"$date"+" | "+$PID+" | Done in "+$est_time+"s" >> $wdir\temp.log
}
function kill_exe {
	$appid = Get-Content $wdir\PID.ini
	kill $appid
	$log_step = 2
	log_entry
	files_del
	#kill $PID
}
function log_entry {
	$date = date
	switch ($log_step)
	{
		0 {
		"===============">> $wdir\temp.log
		"$date | $PID | Starting script" >> $wdir\temp.log}
		1 {
		"$date | $PID | Starting exe file" >> $wdir\temp.log}
		2 {
		"$date | $PID | Stopping exe by PID" >> $wdir\temp.log
		"APP ID | " + $appid + " | stopped" >> $wdir\temp.log
		$text = Get-Content $wdir\temp.log
		$text >> $dir\update.log		
		}
        default {"The color could not be determined."}
    }
}		
#==================SCRIPT
files_create
log_entry
start_exe
wait_marker
kill_exe
exit