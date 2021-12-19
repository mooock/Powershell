[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12;
Function Get-HueLight {
Param(
$IP    = 'HUEBRIDGEIP',
$Token = "HUEBRIDGETOKEN",
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
Function Send-Pushbullet {
    <#
    .SYNOPSIS
        Send-Pushbullet can be used with the Pushbullet service to send notifications to your devices.

    .DESCRIPTION
        This function requires an account at Pushbullet. Register at http://pushbullet.com and obtain your API Key from the account settings section.

        With this module you can send messages or links from a remote system to all of your devices.
   
    .EXAMPLE
        Send-Pushbullet -APIKey "XXXXXX" -Title "Hello World" -Message "This is a test of the notification service."

        Send a message to all your devices.

    .EXAMPLE
        Send-Pushbullet -APIKey "XXXXXX" -Title "Here is a link" -Link "http://pushbullet.com" -DeviceIden "XXXXXX"

        Send a link to one of your deivces. Use Get-PushbulletDevices to get a list of Iden codes.

    .EXAMPLE
        Send-Pushbullet -APIKey "XXXXXX" -Title "Hey there" -Message "Are you here?" -ContactEmail "user@example.com"

        Send a message to a remote user.
    #>
    param([Parameter(Mandatory=$True)][string]$APIKey=$(throw "APIKey is mandatory, please provide a value."), [Parameter(Mandatory=$True)][string]$Title=$(throw "Title is mandatory, please provide a value."), [string]$Message="", [string]$Link="", [string]$DeviceIden="", [string]$ContactEmail="")
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    [System.Net.ServicePointManager]::ServerCertificateValidationCallback = {$true}
    if($Link -ne "")
    {
        $Body = @{
            type = "link"
            title = $Title
            body = $Message
            url = $Link
            device_iden = $DeviceIden
            email = $ContactEmail
        }
    }
    else
    {
        $Body = @{
            type = "note"
            title = $Title
            body = $Message
            device_iden = $DeviceIden
            email = $ContactEmail
        }
    }

    $Creds = New-Object System.Management.Automation.PSCredential ($APIKey, (ConvertTo-SecureString $APIKey -AsPlainText -Force))
    Invoke-WebRequest -Uri "https://api.pushbullet.com/v2/pushes" -Credential $Creds -Method Post -Body $Body
}
Function Set-HueAlarm {
param (
	$APIKey  = "HUEAPIKEY",
	$Title   = "Alarm Triggered",
	$Message = "Hue Motion Sensor detected a trigger event",
	$Timer   = "10"
)
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    $stepCounter = 0

    1..$timer | ForEach-Object {
        $stepCounter++
        
        Write-Progress -Activity 'Arming Alarm' -Status "Arming in $($timer - $stepCounter) Seconds" -PercentComplete ((($stepCounter) / $timer) * 100)
        Sleep 1
    }
    Send-Pushbullet -APIKey $APIKey -Title "Alarm Armed" -Message "Hue alarm is active" | Out-Null

    Write-Progress -Activity 'Arming Alarm' -Status 'Armed' -PercentComplete 0
    sleep 2
    Write-Progress -Activity 'Arming Alarm' -Status 'Armed' -PercentComplete 100 -Completed

    while($true) {       
        [PSCUSTOMOBJECT]@{
            Date  = (Get-Date)
            Alarm = 'Active'
        }
        Do {          
            $AlertStatus = (Get-HueLight -ID 7).on
            Sleep 1
        } While (-not $AlertStatus)

        Send-Pushbullet -APIKey $APIKey -Title $Title -Message $Message | Out-Null
        [PSCUSTOMOBJECT]@{
            Date = (Get-Date)
            Alarm = 'Triggered'
        }

        Do {
            $AlertStatus = (Get-HueLight -ID 7).on
            sleep 1
        } While ($AlertStatus)
    }
}
