# cmd> Powershell.exe -executionpolicy bypass -File getfreshness.ps1

param([string]$azureContentDir)


#$azureContentDir = "c:\\Users\\diberry\\repos\\azure-docs-pr\\articles\\cognitive-services\\"
Write-Host $azureContentDir

# Freshness is 90, but subtract 10 because
# we want to catch them before they are overdue
$olderThan = 80

$files = get-childitem -recurse $azureContentDir -filter *.md -exclude media 

#Get today's date
$now = Get-Date

Write-Host $now

#Create a new array
$filesWithDates=@()

#Loop through the files
ForEach($file in $files) {
 
  Write-Host $file.FullName 

  #Find the date values
  $content = get-content $file.FullName 

  $author = $content | select-string -pattern "ms.author: "
  if($author) {
    $author = $author.Line.ToString().Replace("ms.author: ","")

    #if more than 1 author is listed, remove comma so that CSV output format isn't bothered
    $author = $author.Replace(",",";")
  }

  $title = $content | select-string -pattern "title: "
  if($title){
    $title = $title.Line.ToString().Replace("title: ","")
    $titleLen = $title.length
  }

  $titleSuffix = $content | select-string -pattern "titleSuffix: "
  if($titleSuffix){
    $titleSuffix = $titleSuffix.Line.ToString().Replace("titleSuffix: ","")
    $titleSuffixLen = $titleSuffix.length
  }

  $titleTotalLen = $titleSuffixLen + $titleLen
  $titleTotal = $title + $titleSuffix

  $description = $content | select-string -pattern "description: "
  if($description){
    $description = $description.Line.ToString().Replace("description: ","")
    $descriptionLen = $description.length
  }

  $manager = $content | select-string -pattern "manager: "
  if($manager){
    $manager = $manager.Line.ToString().Replace("manager: ","")
  }
  
  $topic = $content | select-string -pattern "topic: "
  if($topic){
    $topic = $topic.Line.ToString().Replace("topic: ","")
  }
  
  $services = $content | select-string -pattern "services: "
  if($services){
    $services = $services.Line.ToString().Replace("services: ","")
  }
  
  $subservice = $content | select-string -pattern "ms.subservice: "
  if($subservice){
    $subservice = $subservice.Line.ToString().Replace("ms.subservice: ","")
  }

  [string]$difference=-1
  [string]$plus90=""

  $date = $content | select-string -pattern "ms.date:"
  $pubdate = $date

  if($date){
    $date = [datetime]$date.ToString().Replace("ms.date: ","")
    #$date = Get-Date -Format d -Date $date
    $pubdate = $date

    $difference = ($date - $now).Days
    #$difference = $difference.Days
    ##$newdiff = [datetime]::parseexact($date, 'dd-MMM-yy', $null)

    $plus90 = Get-Date (Get-Date $date).AddDays(90) -Format d
  }



  $fileWithDate = new-object System.Object

  $fileWithDate | add-member -MemberType NoteProperty -name DaysOld -value $difference
  $fileWithDate | add-member -MemberType NoteProperty -name 90DaysOldDate -value $plus90
  $fileWithDate | add-member -MemberType NoteProperty -name PubDate -value $pubdate
  $fileWithDate | add-member -MemberType NoteProperty -name FileNameLength-80-or-less -value $file.Name.length
  $fileWithDate | add-member -MemberType NoteProperty -name TitleLength-59-or-less -value $titleTotalLen
  $fileWithDate | add-member -MemberType NoteProperty -name DescriptionLength-75-to-300 -value $descriptionLen
  $fileWithDate | add-member -MemberType NoteProperty -name Author -Value $author
  $fileWithDate | add-member -MemberType NoteProperty -name Manager -Value $manager
  $fileWithDate | add-member -MemberType NoteProperty -name Topic -Value $topic
  $fileWithDate | add-member -MemberType NoteProperty -name Services -Value $services
  $fileWithDate | add-member -MemberType NoteProperty -name Subservice -Value $subservice
  $fileWithDate | add-member -MemberType NoteProperty -name FileName -Value $file.Name
  $fileWithDate | add-member -MemberType NoteProperty -name FolderName -Value $file.DirectoryName
  $fileWithDate | add-member -MemberType NoteProperty -name Title -Value $titleTotal
  $fileWithDate | add-member -MemberType NoteProperty -name Description -Value $description

  #Add the object to the array
  $filesWithDates+=$fileWithDate

}
Write-Host "done processing files"

$outfilename = $("freshness-{0}.csv" -f $(Get-Date -format 'yyyyMMdd'));

$filesWithDates | ConvertTo-Csv -NoTypeInformation | % {$_.Replace('"','')} | Out-File $outfilename
Write-Host "done creating $outfilename"
Write-Host $now
$now = Get-Date
Write-Host $now
