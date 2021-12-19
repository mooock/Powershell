$searchString =  'pitbull'
$results = (Invoke-WebRequest "https://slider.kz/vk_auth.php?q=$searchString" -DisableKeepAlive).content
$results = $results.replace('""', '"MusicArray"')
$results = $results | ConvertFrom-Json
$results.audios.MusicArray | ForEach-Object {
    [PSCUSTOMOBJECT]@{
            Id       = $_.id
            Duration = $_.duration
            Title    = $_.tit_art
            Url      = $_.url
            Extra    = $_.extra
            Link     = "https://slider.kz/download/$($_.id)/$($_.duration)/$($_.url)/$($_.tit_art).mp3?extra=$($_.extra)"
        }
}
