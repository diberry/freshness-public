# cmd> Powershell.exe -executionpolicy bypass -File getfreshness.ps1

#param([string]$azureContentDir)


# insert into SQL server

$connectionString = "Server=tcp:diberry-personal.database.windows.net,1433;Initial Catalog=diberry-personal;Persist Security Info=False;User ID=Sql;Password=Redrum1!;MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"


$freshnessTableName = "[diberry-personal].[dbo].[tbl_Freshness]";

$dropTable = "drop table $freshnessTableName"


$azureContentDir = "c:\\Users\\diberry\\repos\\azure-docs-pr-2\\articles\\cognitive-services\\"
Write-Host $azureContentDir

# Freshness is 90, but subtract 10 because
# we want to catch them before they are overdue
$olderThan = 80

$files = get-childitem -recurse $azureContentDir -filter *.md -exclude media 

#Get today's date
$now = Get-Date

Write-Host $now

Invoke-Sqlcmd $connectionString -Query "SELECT  * FROM $freshnessTableName" | format-table -AutoSize

Write-Host "done processing files"
$filesWithDates | ConvertTo-Csv -NoTypeInformation | % {$_.Replace('"','')} | Out-File freshness.csv
Write-Host "done creating freshness.csv"




Write-Host $now
$now = Get-Date
Write-Host $now
