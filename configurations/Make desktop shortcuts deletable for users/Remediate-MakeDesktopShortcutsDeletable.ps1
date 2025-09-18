$defaultProfileDesktopPath = "C:\Users\Public\Desktop\"
$shortcutsToExclude = @()

$shortcuts = Get-ChildItem -Path $defaultProfileDesktopPath -Filter "*.lnk" | Where-Object { $_.Name -notin $shortcutsToExclude }
$shortcuts | ForEach-Object {
    $objectAcl = Get-Acl -Path ($_.FullName)
    $localUsersGroup = New-Object System.Security.Principal.SecurityIdentifier("S-1-5-32-545")
    $aclRule = New-Object System.Security.AccessControl.FileSystemAccessRule($localUsersGroup, "Modify", "Allow")
    $objectAcl.SetAccessRule($aclRule)
    Set-Acl -Path ($_.FullName) -AclObject $objectAcl
}