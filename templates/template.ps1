$app = Start-Process notepad -passthru
$app.Id > C:\temp\PID.ini
kill $app.id