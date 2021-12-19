Function Set-Desktop {
Param(
  [SWITCH]$MinimizeAllWindows,
  [SWITCH]$MaximizeAllWindows,
  [SWITCH]$HideTaskBar,
  [SWITCH]$RestoreTaskBar,
  [SWITCH]$HideDesktopIcons,
  [SWITCH]$RestoreDesktopIcons,
  [STRING]$ApplicationFocus
)
    If ($MinimizeAllWindows) {
        (New-Object -ComObject "Shell.Application").minimizeall()
    }
    
    If ($MaximizeAllWindows) {
        (New-Object -ComObject "Shell.Application").undominimizeall()
    }
    If ($HideTaskBar -or $RestoreTaskBar) {
        $ExplorerSettings      = 'HKCU:SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\StuckRects3'
        $ExplorerSettingsValue = (Get-ItemProperty -Path $ExplorerSettings).Settings
        If ($HideTaskBar) {
            $ExplorerSettingsValue[8]=3
        }
        If ($RestoreTaskBar) {
            $ExplorerSettingsValue[8]=0
        }
        Set-ItemProperty -Path $ExplorerSettings -Name Settings -Value $ExplorerSettingsValue
    }
    If ($ApplicationFocus) {
        (New-Object -ComObject WScript.Shell).AppActivate((get-process $ApplicationFocus).MainWindowTitle) | Out-Null
    }
    If ($HideDesktopIcons) {
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "NoDesktop" -Value "1"
    }
    If ($RestoreDesktopIcons) {
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "NoDesktop" -Value "0"
    }
    If ($HideDesktopIcons -or $RestoreDesktopIcons -or $RestoreTaskBar -or $HideTaskBar) {
        Stop-Process -Force -ProcessName explorer
    }
}
