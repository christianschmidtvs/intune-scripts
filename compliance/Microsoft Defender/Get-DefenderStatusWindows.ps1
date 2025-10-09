$defenderRegPath = "HKLM:\SOFTWARE\Microsoft\Windows Advanced Threat Protection\Status"

If (Test-Path -Path $defenderRegPath) {
    Try {
        $onboardingState = (Get-ItemProperty -Path $defenderRegPath -Name "OnboardingState").OnboardingState
        Write-Output "OnboardingState: $ondboardingState"
    }
    Catch {
        Write-Warning "Failed to get OnboardingState property from '$defenderRegPath'."
    }
    Try {
        $orgId = (Get-ItemProperty -Path $defenderRegPath -Name "OrgId").OrgId
        Write-Output "OrgId: $orgId"
    }
    Catch {
        Write-Warning "Failed to get OrgId property from '$defenderRegPath'."
    }
}
Else {
    Write-Warning "Registry key '$defenderRegPath' not found."
}

$defenderOnboardingStatusResult = [PSCustomObject]@{
    'OnboardingState' = $onboardingState;
    'OrgId' = $orgId;
}

$defenderOnboardingStatusResult | ConvertTo-Json -Compress