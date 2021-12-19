#Example get-childitem -path M4afilepath | extract-audio

Function Extract-Audio {
param(
[STRING]$FFMPEGEXE = "P:\Video Editing\ffmpeg-4.3.1-2020-10-01-full_build\bin\ffmpeg.exe",
    [parameter(ValueFromPipeline = $true)]
[STRING]$Source,
[STRING]$Destination = 'M:\Music\MP3 Youtube Concerts\Audio',
[STRING]$DestinationExtention='aac'
)

    PROCESS{
        $FileExist = $false
        $Source = $_.fullname
        $Name = $_.basename
        $outputName = $name+'.'+$DestinationExtention
        $Fullpath = Join-Path -Path $Destination -ChildPath $outputName
        $args = @('-i',"`"$Source`"",'-acodec', 'copy',"`"$Fullpath`"") -join " "
        If (Test-path $Fullpath) {
            $FileExist = $true
        } else {
            Start-Process -FilePath $FFMPEGEXE -ArgumentList $args -NoNewWindow -Wait
        }
        [PSCUSTOMOBJECT]@{
            Source      = $Source
            Destination = $Fullpath
            Codec       = $DestinationExtention
            Status      = If ((Test-Path $Fullpath) -and (-not $FileExist)) {'OK'} elseif ($FileExist) {'Exist'} else {'Failed'}
        }
    }
}
