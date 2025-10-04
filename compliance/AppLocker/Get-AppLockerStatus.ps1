$serviceName = "AppIDSvc"
$service = Get-Service -Name $serviceName

$appLockerStatusResult = [PSCustomObject]@{
    'ServiceState' = ($service.Status)
}

$appLockerStatusResult | ConvertTo-Json -Compress