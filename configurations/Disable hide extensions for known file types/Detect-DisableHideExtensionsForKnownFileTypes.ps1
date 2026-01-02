$registryPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
$registryPropertyName = "HideFileExt"
$registryPropertyValue = 0
If ((Get-ItemProperty -Path $registryPath -Name $registryPropertyName).$registryPropertyName -ne $registryPropertyValue) {
    Write-Output "Setting not configured as desired"
    Exit 1
}
Else {
    Write-Output "Compliant"
    Exit 0
}