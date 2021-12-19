$ScriptPath = "C:\startup\Home Automation"

$Scripts = ('Get-huelight.ps1',
            'Set-huelight.ps1',
            'Set-huesync.ps1',
            'Get-TV.ps1',
            'Set-TV.ps1',
            'Get-SunriseSunset.ps1',
            'Set-Desktop.ps1',
            'Set-DisplayFusion.ps1',
            'Set-Fullscreenbackground.ps1',
            'Set-PowerOption.ps1',
            'Set-Receiver.ps1',
            'Set-WindowState.ps1'
            )

Foreach ($script in $scripts) {
    $ScriptFilePath = "$ScriptPath\$script"
    If (Test-Path $ScriptFilePath) {
        . "$ScriptFilePath"
    }
    Else {
        Write-host "Script File missing $ScriptFilePath"
        Break
    }
}

If ((Get-TV -PowerStatus) -eq 'standby') {
    Set-TV -Power ON
    Sleep 25
}

Set-Receiver -Volume 25
Start-Sleep -Seconds 5
Set-DisplayFusion -Profile "TV 1080P 120HZ"
sleep 5
Set-TV       -Source HDMI3
Set-Receiver -Source BD-DVD
