$serviceName = "AppIDSvc"
$service = Get-Service -Name $serviceName

$intuneAppLockerPolicyFiles = Get-ChildItem -Recurse -Path "C:\Windows\System32\AppLocker\MDM" -File | Where-Object { $_.Name -eq "Policy" }
$intuneAppLockerPolicyFiles | ForEach-Object {
    $intuneAppLockerPolicyXml = New-Object System.Xml.XmlDocument
    $intuneAppLockerPolicyXml.Load($_.FullName)
    If ($intuneAppLockerPolicyXml.RuleCollection.Type -eq "Appx") {
        $appxPolicyEnforcementMode = $intuneAppLockerPolicyXml.RuleCollection.EnforcementMode
    }
    ElseIf ($intuneAppLockerPolicyXml.RuleCollection.Type -eq "Dll") {
        $dllPolicyEnforcementMode = $intuneAppLockerPolicyXml.RuleCollection.EnforcementMode
    }
    ElseIf ($intuneAppLockerPolicyXml.RuleCollection.Type -eq "Exe") {
        $exePolicyEnforcementMode = $intuneAppLockerPolicyXml.RuleCollection.EnforcementMode
    }
    ElseIf ($intuneAppLockerPolicyXml.RuleCollection.Type -eq "Msi") {
        $msiPolicyEnforcementMode = $intuneAppLockerPolicyXml.RuleCollection.EnforcementMode
    }
    ElseIf ($intuneAppLockerPolicyXml.RuleCollection.Type -eq "Script") {
        $scriptPolicyEnforcementMode = $intuneAppLockerPolicyXml.RuleCollection.EnforcementMode
    }
}


$appLockerStatusResult = [PSCustomObject]@{
    'ServiceState' = ($service.Status);
    'AppxPolicyEnforcementMode' = $appxPolicyEnforcementMode;
    'DllPolicyEnforcementMode' = $dllPolicyEnforcementMode;
    'ExePolicyEnforcementMode' = $exePolicyEnforcementMode;
    'MSIPolicyEnforcementMode' = $msiPolicyEnforcementMode;
    'ScriptPolicyEnforcementMode' = $scriptPolicyEnforcementMode;
}

$appLockerStatusResult | ConvertTo-Json -Compress