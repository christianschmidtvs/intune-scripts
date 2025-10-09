$windowsUpdateSession = New-Object -ComObject 'Microsoft.Update.Session'
$updateSearcher = $windowsUpdateSession.CreateupdateSearcher()
$updateHistoryCount = $updateSearcher.GetTotalHistoryCount()
$allUpdates = $updateSearcher.QueryHistory(1, $updateHistoryCount)
$cumulativeUpdates = @()
$allUpdates | Where-Object { $_.Title -like "*(KB*)*" } | ForEach-Object {
    If ($_.Categories.Count -eq 0) {
        $cumulativeUpdates += $_
    }
}

$latestCu = $cumulativeUpdates | Sort-Object -Property Date -Descending | Select-Object -First 1
If ($null -ne $latestCu -and $latestCu.Count -ne 0) {
    $daysSinceLastCuInstall = (New-TimeSpan -Start $latestCu.Date -End (Get-Date)).Days
}

$windowsUpdateStatusResult = [PSCustomObject]@{
    'LastCuAgeDays' = $daysSinceLastCuInstall;
}

$windowsUpdateStatusResult | ConvertTo-Json -Compress