$exefile = "C:\Users\Ivan\Desktop\iperf.exe"
$arguments = "-c 192.168.1.35"
$app = start-process $exefile $arguments -PassThru
sleep 5
kill $app.id