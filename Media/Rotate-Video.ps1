#Example get-childitem -path M4afilepath | extract-audio

Function Rotate-Video {
param(
[STRING]$FFMPEGEXE = "P:\Video Editing\ffmpeg-4.3.1-2020-10-01-full_build\bin\ffmpeg.exe",
    [parameter(ValueFromPipeline = $true)]
[STRING]$Source      = "D:\Video\Source",
[STRING]$Destination = 'D:\Video\Destination',
[STRING]$DestinationExtention='mp4'
)

        (Get-ChildItem $Source) | ForEach-Object {
        $FileExist = $false
        $Source = $_.fullname
        $Name = $_.basename
        $outputName = $name+'.'+$DestinationExtention
        $Fullpath = Join-Path -Path $Destination -ChildPath $outputName
        $Regex = "(\w+)=\s+(\d+)\s+(\w+)=(\d+.\d+)\s+(\w)=(\d+.\d+)\s+(\w+)=\s+(\d+)\w+\s+(\w+)=(\d+:\d+:\d+.\d+)\s+(\w+)=(\d+.\d+)\w+\/s\s+(\w+)=(\d+.\d+)"
        &$FFMPEGEXE -i $Source -vf transpose=clock $Fullpath 2>&1 | Select-String -Pattern $Regex  | ForEach-Object {

        $output = ($_ | Select-String -Pattern $regex).Matches.Groups
        [PSCUSTOMOBJECT]@{
            Source      = $source
            Destination = $Fullpath
            $output[1]  = $output[2]
            $output[3]  = $output[4]
            $output[5]  = $output[6]
            $output[7]  = $output[8]
            $output[9]  = $output[10]
            $output[11] = $output[12]
            $output[13] = $output[14]
        }
        }
        }
}
