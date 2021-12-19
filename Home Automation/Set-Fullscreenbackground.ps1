Function Set-Fullscreenbackground {
param(
  $InfraviewPath       = "C:\Programs\Powershell\GameModule\Bin\i_view64.exe",
  $BackgroundImage     = "C:\Programs\Powershell\GameModule\Pictutes\loading.jpg",
  $ApplicationStart,
  [SWITCH]$Stop,
  [SWITCH]$NoProcessStop
)
    If ($Stop){
        Start-Process -FilePath $InfraviewPath -ArgumentList "/killmesoftly"
    } Else {
        $IfraviewProcess = Start-Process -FilePath $InfraviewPath  -ArgumentList $BackgroundImage -PassThru
        Start-Sleep -Seconds 1
    
        If ($ApplicationStart) {
            $ApplicationProcess = Start-Process -FilePath $ApplicationStart -NoNewWindow -PassThru
            do {
                $ProcessFound = Get-Process -Name $ApplicationProcess.ProcessName -ErrorAction SilentlyContinue
                Start-Sleep -Seconds 1
            } Until ($ProcessFound)
        }
    
        if ($ApplicationStart -and $IfraviewProcess -and -not $NoProcessStop) {
            Start-Sleep 5
            $IfraviewProcess | Stop-Process 
        }
    }
}
