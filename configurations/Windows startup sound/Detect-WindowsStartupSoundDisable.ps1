$registryPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
$registryPropertyName = "DisableStartupSound"
$registryPropertyDesiredValue = 1

Try {
    $registryPropertyValue = (Get-ItemProperty -Path $registryPath -Name $registryPropertyName -ErrorAction Stop).$registryPropertyName
    If ($registryPropertyValue -eq $registryPropertyDesiredValue) {
        Write-Output "Compliant"
        Exit 0
    }
    Else {
        Write-Output "Non-Compliant"
        Exit 1
    }
}
Catch {
    Write-Error "Non-Compliant: Error retrieving registry property value: $_"
    Exit 1
}