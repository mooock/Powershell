Function Set-SonyBraviaTV {
Param(
    [ValidateSet("HDMI3","SHIELD")]
    [STRING]$Source,
    [STRING]$URI='http://IPADRESS',
    [STRING]$Password='0110',
    [ValidateSet("ON","OFF")]
    [STRING]$Power,
    [SWITCH]$Status,
    [SWITCH]$CurrentInput,
    [SWITCH]$Volume
    )

    $headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
    $headers.Add("Content-Type", "application/json")
    $headers.Add("X-Auth-PSK", $Password)

    If ($Source) {
        If ($Source -like "HDMI3") {
            $Command = @{
                Uri     = "$URI/sony/avContent"
                Body    = '{"method":"setPlayContent","id":101,"params":[{"uri":"extInput:hdmi?port=3"}],"version":"1.0"}'
                Method  = 'Post'
            }
        }
        ElseIf ($Source -like "SHIELD") {
            $Command = @{
                Uri     = "$URI/sony/avContent"
                Body    = '{"method":"setPlayContent","id":101,"params":[{"uri":"extInput:cec?type=player&port=3&logicalAddr=4"}],"version":"1.0"}'
                Method  = 'Post'
            }
        }

    }
    If ($Power) {
        if ($Power -like 'ON') {
            $Command=@{
                Body = '{"id": 55, "method": "setPowerStatus", "version": "1.0", "params": [{"status": true}]}'
                Method = 'Post'
                URI = $URI+"/sony/system"
            }
        }

        Elseif ($Power -like 'OFF') {
            $Command=@{
                Body = '{"id": 55, "method": "setPowerStatus", "version": "1.0", "params": [{"status": false}]}'
                Method = 'Post'
                URI = $URI+"/sony/system"
            }
        }
    }
    if ($CurrentInput) {
        $Command=@{
            Body = '{"method":"getCurrentExternalInputsStatus","id":105,"params":[],"version":"1.1"}'
            Method = 'Post'
            URI = $URI+"/sony/avContent"
        }
    }

    if ($Status) {
        $Command=@{
            Body =  '{"method":"getPlayingContentInfo","id":103,"params":[],"version":"1.0"}'
            Method = 'Post'
            URI = $URI+"/sony/avContent"
        }
    }

    if ($Volume) {
        $Command=@{
            Body =  '{"method":"setAudioVolume","id":98,"params":[{"volume":"25","ui":"on","target":""}],"version":"1.2"}'
            Method = 'Post'
            URI = $URI+"/sony/audio"
        }
    }



    If ($Source -or $Power) {
        Invoke-RestMethod -Headers $Headers @Command | Out-Null
    } Else {
        (Invoke-RestMethod -Headers $Headers @Command).result
    }
}
