$ScriptPath = "C:\startup\Home Automation"
$TVShutdownTimer = 5
$PCShutdownTimer = 5

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

Get-Process -Name Playnite.FullscreenApp | Stop-Process

If ((Get-SunriseSunset).night) {
    Get-HueLight -Group 'Light Strips'     | Set-HueLight -Off
    Get-HueLight -Group 'Gradient'         | Set-HueLight -off
    Get-HueLight -Group 'Living Room Plug' | Set-HueLight -On
    Get-HueLight -Group 'Kitchen'          | Set-HueLight -On -Brightness 210 -Hue 5500 -Sat 254
    Set-HueSync  -Off
}

Set-DisplayFusion -Profile 'Monitor'
Set-Desktop -MaximizeAllWindows -RestoreTaskBar -RestoreDesktopIcons

If ($TVShutdownTimer -gt 0) {
    1..$TVShutdownTimer | foreach {
        Sleep 1
        Write-Progress -Activity "Power Off TV in progress" -PercentComplete (100/$TVShutdownTimer * $_)      
    }
    Set-TV -Power OFF
}

If ($PCShutdownTimer -gt 0) {
    1..$PCShutdownTimer | foreach {
        Sleep 1
        Write-Progress -Activity "Power Off TV in progress" -PercentComplete (100/$PCShutdownTimer * $_)
    }
    Set-PowerOption -Power Hibernate
}
