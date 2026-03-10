param (
    [string]$Csv1Path = "./kinly_data.csv",
    [string]$Csv2Path = "./blob_data.csv",
    [string]$ColumnName = "recordings"
)

# Import CSV files
Write-Host "Import files"
$csv1 = Import-Csv $Csv1Path
$csv2 = Import-Csv $Csv2Path

# Group and count recordings
Write-Host "Group recordings"
$counts1 = $csv1 | Group-Object $ColumnName
$counts2 = $csv2 | Group-Object $ColumnName

# Create lookup tables for counts
Write-Host "Build count lookups"
$lookup1 = @{}
foreach ($item in $counts1) {
    $lookup1[$item.Name] = $item.Count
}

$lookup2 = @{}
foreach ($item in $counts2) {
    $lookup2[$item.Name] = $item.Count
}

# Create lookup table for FIRST case value only
Write-Host "Build case lookup (first only)"
$caseLookup = @{}
foreach ($row in $csv2) {
    $rec  = $row.$ColumnName
    $case = $row.case

    if (-not $caseLookup.ContainsKey($rec) -and $case) {
        $caseLookup[$rec] = $case
    }
}

# Union of all recording names
$allRecordings = ($lookup1.Keys + $lookup2.Keys) | Sort-Object -Unique

# Compare counts and output ONLY differences
Write-Host "Compare"
$results = foreach ($rec in $allRecordings) {

    $count1 = if ($lookup1.ContainsKey($rec)) { $lookup1[$rec] } else { 0 }
    $count2 = if ($lookup2.ContainsKey($rec)) { $lookup2[$rec] } else { 0 }

    if ($count1 -ne $count2) {

        $caseValue = if ($caseLookup.ContainsKey($rec)) { $caseLookup[$rec] } else { "" }

        # 🔹 Derive Room Number
        $roomNumber = if ($caseValue -match "^([^/]+)/") {
            $matches[1]
        } else {
            ""
        }

        # 🔹 Derive Date (dd/MM/yyyy)
        $dateValue = ""
        if ($caseValue -match "_(\d{4})-(\d{2})-(\d{2})") {
            $dateValue = "{0}/{1}/{2}" -f $matches[3], $matches[2], $matches[1]
        }

        [PSCustomObject]@{
            Date         = $dateValue
            Recording    = $rec
            Room_Number  = $roomNumber
            Case         = $caseValue
            Kinly_Count  = $count1
            Blob_Count   = $count2
            Diff         = [Math]::Abs($count1 - $count2)
        }
    }
}

# Export result to CSV
Write-Host "Result:"
if ($results) {
    $results | Export-Csv "./Recording_Differences.csv" -NoTypeInformation
    Write-Host "CSV exported successfully." -ForegroundColor Green
}
