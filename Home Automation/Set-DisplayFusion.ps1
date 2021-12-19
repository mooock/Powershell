Function Set-DisplayFusion {
    Param(
    [ArgumentCompleter(
        {
            $Regkey = "HKEY_USERS\S-1-5-21-3038841078-4106342563-1681394413-1001\SOFTWARE\Binary Fortress Software\DisplayFusion\MonitorProfiles"
            $RegMonitorProfiles = Get-Item -Path "Registry::$Regkey"
            $RegMonitorProfiles.GetSubKeyNames() | foreach {
                $RegMonitorProfilesSubkey = "$Regkey\$_"
                '"' + ((Get-ItemProperty -Path "Registry::$RegMonitorProfilesSubkey").Name) + '"'
            }
        }
    )]
    [ValidateScript(
        {$_ -in $_}
    )]
    [STRING]$Profile
    )
    If ($Profile) {
        $ExecuteFile = (Get-ItemProperty -Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\B076073A-5527-4f4f-B46B-B10692277DA2_is1\").DisplayIcon
        $ExecuteFile = $ExecuteFile | Split-Path -Parent | Join-Path -ChildPath 'DisplayFusionCommand.exe'
        &$ExecuteFile -monitorloadprofile $Profile
    }
}
