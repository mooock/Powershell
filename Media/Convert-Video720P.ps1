Function Convert-Video720P {
param(
[STRING]$FFMPEGEXE = "P:\Video Editing\ffmpeg-4.3.1-2020-10-01-full_build\bin\ffmpeg.exe",
    [parameter(ValueFromPipeline = $true)]
[STRING]$Source      = "D:\Video\Source",
[STRING]$Destination = 'D:\Video\Destination',
[STRING]$Procssed   = 'D:\Video\Procssed',
[STRING]$DestinationExtention='mp4',
[INT]$CompressionLevel = 31
)
    $StartTime = $(get-date)
    $i = 0
    $SourceItems = Get-ChildItem $Source
    $TotalItems = ($SourceItems).count
    $SecondsRemaining = 0
    $SourceItems| ForEach-Object {
    ++$i 
    Write-Progress -Activity "Converting $_ to X265 MP4 $i/$TotalItems " -PercentComplete ($i/ $TotalItems * 100) -SecondsRemaining $SecondsRemaining

        $FileExist = $false
        $Source = $_.fullname
        $Name = $_.basename
        $outputName = $name+'.'+$DestinationExtention
        $Fullpath = Join-Path -Path $Destination -ChildPath $outputName
        $Regex = "(\w+)=\s+(\d+)\s+(\w+)=(\d+.\d+)\s+(\w)=(\d+.\d+)\s+(\w+)=\s+(\d+)\w+\s+(\w+)=(\d+:\d+:\d+.\d+)\s+(\w+)=(\d+.\d+)\w+\/s\s+(\w+)=(\d+.\d+)"
        
        #Measures time for the execution
        $duration = Measure-Command -Expression {
            &$FFMPEGEXE -i $Source -vf scale=-1:720 -c:v libx265 -x265-params crf=$CompressionLevel -c:a aac -b:a 128k $Fullpath 2>&1  | Select-String -Pattern $Regex 
        }

        $Destinationfile = Get-ChildItem $Fullpath
        [PSCUSTOMOBJECT]@{
            Source      = $_.FullName
            Source_Size = $_.Length
            Destination = $Destinationfile.FullName
            Destination_Size = $Destinationfile.Length
            Duration    = $duration.TotalSeconds
            Compression = ($_.Length - $Destinationfile.Length) / $_.Length * 100
        }

        #Moving to processed folder
        Move-Item -Path $_.FullName -Destination $Procssed

        #Time remaining calculation
        $elapsedTime = $(get-date) - $StartTime
        $durationTotal += $duration.TotalSeconds
        $SecondsRemaining = ($durationTotal / $i * $TotalItems) - $elapsedTime.TotalSeconds
    }
}

