$now = Get-Date
Write-Host $now

$newnow = $now.ToString("yyyyMMdd")
Write-Host $newnow

$outfilename = $("freshness-{0}.csv" -f $(Get-Date -format 'yyyyMMdd'));
Write-Host $outfilename
