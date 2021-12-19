$ScriptPath = "C:\startup\Scripts"
$TVShutdownTimer = 20
$PCShutdownTimer = 30

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

Set-Desktop -MinimizeAllWindows
Set-Desktop -HideTaskBar -HideDesktopIcons
Set-Receiver -Volume 25
Start-Sleep -Seconds 5
Set-DisplayFusion -Profile 'TV 2160P'
Set-Desktop -MinimizeAllWindows
Start-Sleep -Seconds 3
Set-Fullscreenbackground

If (((Get-SunriseSunset).night)) {

    Set-HueSync -On
    Get-HueLight                           | Set-HueLight -Off
    Get-HueLight -Group 'Gradient'         | Set-HueLight -On -Brightness 100 -Hue 100 -Sat 254
    Get-HueLight -Group 'Kitchen'          | Set-HueLight -On -Brightness 40  -Hue 100 -Sat 254
    Get-HueLight -Group 'Living Room Plug' | Set-HueLight -off
    Get-HueLight -Group 'Living Room Plug' | Set-HueLight -off
}
sleep 5
Set-TV       -Source HDMI3
Set-Receiver -Source BD-DVD

sleep 3
$playniteID = Start-Process "Playnite.FullscreenApp.exe" -NoNewWindow -PassThru
sleep 2

Start-Process "Playnite.FullscreenApp.exe" -NoNewWindow -PassThru
sleep 1
Set-Fullscreenbackground -Stop
