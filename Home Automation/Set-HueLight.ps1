Function Set-HueLight {
Param(
    $IP    = 'HUEIP',
    $Token = "HUETOKEN",
    [parameter(
    ValueFromPipelineByPropertyName = $true)]
    [INT[]]$ID,
    
    [SWITCH]$On,
    [SWITCH]$Off,
    [ValidateRange(0,254)]
    [INT]$Brightness,
    [ValidateRange(0,65535)]
    [INT]$Hue,
    [ValidateRange(0,254)]
    [INT]$Sat
    
    )
    BEGIN {
        $URI = "http://$IP/api/$Token/lights"
        $lights = Get-HueLight -Settings
        $ID = @()
    }
    
    PROCESS {
        Foreach ($IDnum in $ID) {
            Sleep -Milliseconds 50
            $Settings = New-Object PSObject
            $StateUri = "$URI/$IDnum/state"
            If ($Brightness) {
                Add-Member -InputObject $Settings -MemberType NoteProperty -Name bri -Value $Brightness
            }
            If ($Sat) {
                Add-Member -InputObject $Settings -MemberType NoteProperty -Name sat -Value $Sat
            }
            If ($Hue) {
                Add-Member -InputObject $Settings -MemberType NoteProperty -Name hue -Value $Hue
            }
            If ($On) {
                Add-Member -InputObject $Settings -MemberType NoteProperty -Name on -Value $true
            }

            Elseif ($off) {
                Add-Member -InputObject $Settings -MemberType NoteProperty -Name on -Value $false
            }
            
            $body = ConvertTo-Json -InputObject $Settings -Compress -Depth 1
            
            Invoke-RestMethod -Uri $StateUri -Method Put -Body $body | Out-Null
            Add-Member -InputObject $Settings -MemberType NoteProperty -Name ID -Value $IDnum
        }
    }
}   
