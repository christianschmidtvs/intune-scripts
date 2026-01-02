$registryPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
$registryPropertyName = "HideFileExt"
$registryPropertyValue = 0
If ((Get-ItemProperty -Path $registryPath -Name $registryPropertyName).$registryPropertyName -ne $registryPropertyValue) {
    Set-ItemProperty -Path -Name $registryPropertyName -Value $registryPropertyValue
}