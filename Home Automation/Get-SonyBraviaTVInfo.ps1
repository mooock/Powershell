Function Get-SonyBraviaTVInfo {
Param(
    [STRING]$URI='http://TVIP',
    [STRING]$Password='TVPASSCODE',
    [SWITCH]$PowerStatus
    )

    $headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
    $headers.Add("Content-Type", "application/json")
    $headers.Add("X-Auth-PSK", $Password)

    if ($PowerStatus) {
        $Command = @{
            Uri     = "$URI/sony/system"
            Body    = '{"method":"getPowerStatus","id":50,"params":[],"version":"1.0"}'
            Method  = 'Post'
        }
    }
    If ($PowerStatus) {
        (Invoke-RestMethod -Headers $Headers @Command).result.status
    }
}
