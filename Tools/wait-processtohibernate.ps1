
$total = (Get-Process | where processname -like chdman).count
do
{
    cls
    $x = (Get-Process | where processname -like chdman).count
    Write-Progress -Status "Chdman processes $x" -Activity "Waiting for hibernate" -PercentComplete ($x / $Total * 100)
    sleep 5
}
until ($x -eq 0)
Write-Progress -Status "no more processes" -Activity "Starting hibernate"
start-process "shutdown" /h
