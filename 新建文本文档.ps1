$n=3
while($n -gt 0)
{
$FILE = New-Item -ItemType file "D:/123/$((Get-Date).ToString('yyyy_MM_dd_HH_mm')).txt"
netstat -an >>$FILE
sleep  60
$n=$n-1
}