$dir = "C:\temp\update"
0 > $dir\end.ini
$request = Get-Content $dir\end.ini
while ($request -eq 0) {
$request = Get-Content $dir\end.ini
echo "sleep 10s"
sleep 10
}
echo "done"