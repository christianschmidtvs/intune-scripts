$defaultProfileDesktopPath = "C:\Users\Public\Desktop\"
$shortcutsToExclude = @()

$shortcuts = Get-ChildItem -Path $defaultProfileDesktopPath -Filter "*.lnk" | Where-Object { $_.Name -notin $shortcutsToExclude }
$compliant = $true
$shortcuts | ForEach-Object {
    $objectAcl = Get-Acl -Path ($_.FullName)
    If ($objectAcl.Sddl -notlike "*(A;;0x1301bf;;;BU)*") {
        $compliant = $false
    }
}

If ($compliant) {
    Write-Output "Compliant"
    Exit 0
}
Else {
    Write-Output "Non-Compliant"
    Exit 1
}