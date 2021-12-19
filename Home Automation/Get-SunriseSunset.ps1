Function Get-SunriseSunset {
param (
$Latitude ='55.676098',
$Longitude = '12.568337'
)

    $Daylight = (Invoke-RestMethod "https://api.sunrise-sunset.org/json?lat=$Latitude&lng=$Longitude&formatted=0").results
    $Daytime  = If ((get-date) -lt (get-date ($Daylight.Sunrise | Get-Date -Format "HH:mm")) -or (get-date) -gt (get-date ($Daylight.sunset | Get-Date -Format "HH:mm"))) {'Night'} else {'Day'}

    [PSCUSTOMOBJECT]@{
        Sunrise  = ($Daylight.Sunrise | Get-Date -Format "HH:mm")
        Sunset   = ($Daylight.Sunset | Get-Date -Format "HH:mm")
        Daytime  = $Daytime
        Night    = if ($Daytime -eq 'Night') {$true} else {$false}
    }
}
