param (
    [string]$Csv1Path = "./kinly_data.csv",
    [string]$Csv2Path = "./blob_data.csv",
    [string]$ColumnName = "recordings"
)

# Import CSV files
Write-Host "import file"
$csv1 = Import-Csv $Csv1Path
$csv2 = Import-Csv $Csv2Path

# Group and count recordings
Write-Host "Group recordings"
$counts1 = $csv1 | Group-Object $ColumnName
$counts2 = $csv2 | Group-Object $ColumnName

# Create lookup tables
Write-Host "Lookup"
$lookup1 = @{}
foreach ($item in $counts1) {
    $lookup1[$item.Name] = $item.Count
}

$lookup2 = @{}
foreach ($item in $counts2) {
    $lookup2[$item.Name] = $item.Count
}

# Union of all recording names
$allRecordings = ($lookup1.Keys + $lookup2.Keys) | Sort-Object -Unique

# Compare counts and output ONLY differences
Write-Host "For each"
$results = foreach ($rec in $allRecordings) {

    if ($lookup1.ContainsKey($rec)) {
        $count1 = $lookup1[$rec]
    } else {
        $count1 = 0
    }

    if ($lookup2.ContainsKey($rec)) {
        $count2 = $lookup2[$rec]
    } else {
        $count2 = 0
    }

    if ($count1 -ne $count2) {
        [PSCustomObject]@{
            Recording   = $rec
            Kinly_Count = $count1
            Blob_Count = $count2
			Difference  = [Math]::Abs($count1 - $count2)
        }
    }
}

# Display output ONLY if differences exist
Write-Host "Result:"
if ($results) {
    $results | Format-Table -AutoSize
}
