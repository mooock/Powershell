Function Get-HueLight {
Param(
$IP    = "HUEBRIDGEIP",
$Token = "HUEBRIDGEAPITOKEN",
[SWITCH]$Status,
[Validateset('PlayOffice','Kitchen','Hue Spots','Light Strips','Living Room Plug','Office','Gradient')]
[STRING[]]$Group,
[INT[]]$ID
)
    $URI = "http://$IP/api/$Token/lights"
    $LightsData = Invoke-RestMethod -Uri $URI -Method Get

    If ($Group) {
        If ($Group -eq 'Gradient') {
          $ID += (Get-HueLight -Settings | where name -Like "*Gradient*").id
        }
        If ($Group -eq 'PlayOffice') {
          $ID += (Get-HueLight -Settings | where name -Like "*play*").id
        }
        If ($Group -eq 'Kitchen') {
          $ID += (Get-HueLight -Settings | where name -Like "*Kitchen light*").id
        }
        If ($Group -eq 'Hue Spots') {
          $ID += (Get-HueLight -Settings | where name -Like "*hue spot*").id
        }
        If ($Group -eq 'Light Strips') {
          $ID += (Get-HueLight -Settings | where name -Like "*strip*").id
        }
        If ($Group -eq 'Living Room Plug') {
          $ID += (Get-HueLight -Settings | where name -Like "*Living Room Plug*").id
        }
        If ($Group -eq 'Office') {
          $ID += (Get-HueLight | Where-Object {($_.name -like "*Office*") -or ($_.name -like "*hue play*")}).id
        }                      
    }

    If ($ID) {
        $LightsIDs = $ID
    } else {
        $LightsIDs = (Get-Member -InputObject $LightsData -MemberType NoteProperty).Name
    }
    $Lights = (Get-Member -InputObject $LightsData -MemberType NoteProperty).Name | ForEach-Object {
        $LightsData.$_
    }
    If ($Status) {
        $Lights | select Name,Type,Productname,uniqueid | Sort-Object name
    }
    If (-not $status) {
        $Output = Foreach ($LightsID in $LightsIDs) {
            [PSCUSTOMOBJECT]@{
                ID         = $LightsID
                Name       = ($LightsData.$LightsID).name
                On         = ($LightsData.$LightsID).state.On
                Brightness = if ((($LightsData.$LightsID).state | Get-Member -Name bri)) {($LightsData.$LightsID).state.bri} else {'0'}
                Satuartion = if ((($LightsData.$LightsID).state  | Get-Member -Name sat)) {($LightsData.$LightsID).state.sat} else {'0'}
                ct         = if ((($LightsData.$LightsID).state  | Get-Member -Name ct)) {($LightsData.$LightsID).state.ct} else {'0'}
                colormode  = if ((($LightsData.$LightsID).state  | Get-Member -Name ct)) {($LightsData.$LightsID).state.ct} else {$false}
                reachable  = ($LightsData.$LightsID).state.reachable
                StateURI   = $URI + '/' + $LightsID + '/state'
            }
        } 
    $Output | Sort-Object name
    }
} 
