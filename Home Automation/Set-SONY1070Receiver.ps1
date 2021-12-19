Function Set-SONY1070Receiver {
Param(
    [ValidateSet("BD-DVD","TV","GAME")]
    [STRING]$Source,
    [STRING]$URI='http://IPANDPORT',
    [ValidateSet("ON","OFF")]
    [STRING]$Power,
    [SWITCH]$Status,
    [INT]$Volume,
    [SWITCH]$CurrentInput
    )
    #APIinfo {"id": 20, "method": "getMethodTypes", "version": "1.0", "params": [""]}
    $Command=@{}
    $Headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
    $Headers.Add("Content-Type", "application/json")


    if ($Volume) {
        $Body = [PSCustomObject]@{
        method = 'setAudioVolume'
        id     = 20
            params = @(
            [PSCustomObject]@{
                volume="$Volume"
                output=''
            }
        
        )
        version = '1.1'
        } | ConvertTo-Json

        $Command=@{
            Body = $Body
            Method = 'Post'
            URI = $URI+"/sony/audio"
        }
    }

    If ($Source) {
        If ($Source -like 'BD-DVD') {
            $Command=@{
                Body = '{"id":47,"method":"setPlayContent","version":"1.2","params":[{"uri":"extInput:bd-dvd"}]}'
                Method = 'Post'
                URI = $URI+"/sony/avContent"
            }
        }

        Elseif ($Source -like 'TV') {
            $Command=@{
                Body = '{"id":47,"method":"setPlayContent","version":"1.2","params":[{"uri":"extInput:tv"}]}'
                Method = 'Post'
                URI = $URI+"/sony/avContent"
            }
        }
        Elseif ($Source -like 'GAME') {
            $Command=@{
                Body = '{"id":47,"method":"setPlayContent","version":"1.2","params":[{"uri":"extInput:game"}]}'
                Method = 'Post'
                URI = $URI+"/sony/avContent"
            }
        }
    }

    If ($Power) {
        if ($Power -like 'ON') {
            $Command=@{
                Body = '{"id":47,"method":"setPlayContent","version":"1.2","params":[{"uri":"extInput:tv"}]}'
                Method = 'Post'
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
    Elseif ($Status) {
        $Command=@{
            Body = '{"method":"getPlayingContentInfo","id":105,"params":[],"version":"1.0"}'
            Method = 'Post'
            URI = $URI+"/sony/avContent"
        }
    }

    Elseif ($CurrentInput) {
        $Command=@{
            Body = '{"method":"getPlayingContentInfo","id":103,"params":[],"version":"1.0"}'
            Method = 'Post'
            URI = $URI+"/sony/avContent"
        }
    }

    If ($Source -or $Power -or $Volume) {
        Invoke-RestMethod -Headers $Headers @Command | Out-Null
    } Else {
        (Invoke-RestMethod -Headers $Headers @Command).result
    }
}
