#ver 0.2b
#SK scripts
#Tyurin Ivan
#====PARAMETERS
$exefile = "C:\Users\Ivan\Documents\GitHub\PShell\pascal_test_exe\test.exe"
$arguments = "-p1"
$dir = "C:\temp\update"
#====VAR
	$request = 0
	$marker = 1
#====FUNCTIONS
function check {
	$checkdir = Test-Path $dir
	$check1 = Test-Path $dir\pid.ini
	$check2 = Test-Path $dir\update.log
	$check3 = Test-Path $dir\end.ini
	if ($checkdir) {} else {
		New-Item $dir -type directory}
	if ($check1) {} else {
		New-Item $dir\pid.ini -type file}
	if ($check2) {} else {
		New-Item $dir\update.log -type file}
	if ($check3) {} else {
		New-Item $dir\end.ini -type file}
}
function start_exe {
	0 > $dir\end.ini
	$date = date
	"$date start update" >> $dir\update.log
	$app = start-process $exefile $arguments -PassThru
	$app.Id > $dir\PID.ini
	}
function wait_marker {
	while ($request -eq 0) {
	$request = Get-Content $dir\end.ini
	echo "sleep 10s"
	sleep 10
	}
	sleep 5
}
function kill_exe {
	$date = date
	"$date killing apps" >> $dir\update.log
	$appid = Get-Content $dir\PID.ini
	kill $appid
	0 > $dir\end.ini
	kill $PID
}
#=====SCRIPT
check
start_exe
wait_marker
kill_exe












