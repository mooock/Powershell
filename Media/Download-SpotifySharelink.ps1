function Download-SpotifySharelink
{
    [CmdletBinding()]
    [Alias()]
    [OutputType([int])]
    Param
    (
        $pythonexe = 'C:\Program Files\Python310\python.exe',
        $Zspotify = 'C:\Temp\zspotify',
        [STRING[]]$Spotifylink,
        [SWITCH]$Search,
        [STRING]$Destination = "c:\temp\download"
    )

    Begin
    {
        Set-location $Zspotify 
        if ($Spotifylink) {
            $uris = $Spotifylink
        } else {
            #ARRAYlist for multiply albums if not provided link for function
[ARRAY]$URIs = @"
https://open.spotify.com/album/5k6SaVFct9oBgTKavntM1o?si=aY7pCVvFSISl9Br51z7otg
https://open.spotify.com/album/5k6SaV3ct9oBgTKavntMGo?si=aYfpCVvFSISl9Br51z7ofg
https://open.spotify.com/album/5k6SaVFct9oBgTKavntMGo?si=aY3pCVvFSISl9Br51z7otg
"@ -split ([Environment]::NewLine)
        }
    }
    Process
    {
        If ($Search) {
            Start-Process -FilePath $pythonexe -ArgumentList "src -s" 
        } else {
            $uris | ForEach-Object {
                Start-Process -FilePath $pythonexe -ArgumentList "src $_ --root-path $Destination" -WorkingDirectory $Zspotify -Wait | Out-Null
            }
        }
    }
    End
    {
    }
}




