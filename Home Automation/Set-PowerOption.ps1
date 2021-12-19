Function Set-PowerOption {
    Param(
    [ValidateSet("Hibernate")]
    [STRING]$Power
    )

    If ($Power -eq 'Hibernate') {
        &"$env:SystemRoot\System32\rundll32.exe" powrprof.dll,SetSuspendState Hibernate
    }
}
