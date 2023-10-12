#Path to files
$macPath = "C:\Users\Administrator\Desktop\"

#Input file
$gtMacList = (Get-Content "$($macPath)\maclist.txt").Replace(" ","")

#tests for if output file exists
if (-not $macPath){new-item "$($macPath)\ouptut.txt" -ItemType File }

#does the biz
foreach($macitem in $gtMacList)
    {
        $macJoin = ($macitem.ToLower() -split "(..)"  | Where-Object {$_}) -join "-"
        Write-Host $macJoin -ForegroundColor Green
        $macJoin | Out-File "$($macPath)\ouptut.txt" -Append    
    }

