$registryPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
$registryPropertyName = "DisableStartupSound"
$registryPropertyDesiredValue = 1

Try {
    $registryPropertyValue = (Get-ItemProperty -Path $registryPath -Name $registryPropertyName -ErrorAction SilentlyContinue).$registryPropertyName
    If ($registryPropertyValue -ne $registryPropertyDesiredValue) {
        Set-ItemProperty -Path $registryPath -Name $registryPropertyName -Value $registryPropertyDesiredValue -ErrorAction Stop
    }
}
Catch {
    Write-Error "Error setting registry property value: $_"
}