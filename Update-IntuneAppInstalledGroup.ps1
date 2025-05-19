<#
.SYNOPSIS
Updates an Entra ID group with computers where a specific app is installed

.DESCRIPTION
Update-IntuneAppInstalledGroup gets computers where a specific app is installed an adds them to an Entra ID group as well as removes computers where this app is no longer installed.

.PARAMETER entraIdTenantId
Entra ID tenant ID where Intune and the groups are located. Can for example be found in the overview of the Entra ID app registration created for this script to run.

.PARAMETER entraIdAppRegistrationAppId
Application / client ID of the app registration created for this script to run in Entra ID.

.PARAMETER entraIdAppRegistrationCertificate
Certificate to use when authenticating against Entra ID via the app registration.

.PARAMETER applicationSearchString
String to search for in the discovered apps on devices to find devices where the app is installed. For example 'My App*', '*My App*' or 'My App'.

.PARAMETER entraIdGroupName
Name of the Entra ID group where devices where the app is installed should be placed in.

.EXAMPLE
Update-IntuneAppInstalledGroup.ps1 -entraIdTenantId "12345678-1234-1234-1234-123456789012" -entraIdAppRegistrationAppId "12345678-1234-1234-1234-123456789012" -entraIdAppRegistrationCertificate "0000000000000000000000000000000" -applicationSearchString "My App*" -entraIdGroupName "int-app-myapp-phase1"

.NOTES
Author: Christian Schmidt
Version: 0.1

Required permissions:
- DeviceManagementManagedDevices.Read.All
- Group.Read.All
- GroupMember.ReadWrite.All
- Device.ReadWrite.All

Required powershell modules:
- Microsoft.Graph.Authentication
- Microsoft.Graph.DeviceManagement
- Microsoft.Graph.Groups

.LINK
https://github.com/christianschmidtvs/intune-scripts/blob/master/Update-IntuneAppInstalledGroup.ps1
#>
param (
    [Parameter(Mandatory=$true)][string]$entraIdTenantId,
    [Parameter(Mandatory=$true)][string]$entraIdAppRegistrationAppId,
    [Parameter(Mandatory=$true)][string]$entraIdAppRegistrationCertificate,
    [Parameter(Mandatory=$true)][string]$applicationSearchString,
    [Parameter(Mandatory=$true)][string]$entraIdGroupName
)

# Import required powershell modules
Try {
    Import-Module Microsoft.Graph.Authentication
    Import-Module Microsoft.Graph.DeviceManagement
    Import-Module Microsoft.Graph.Groups
}
Catch {
    Write-Error "Problem loading required powershell modules. Please make sure all required modules are installed (see help)."
    break
}

# Connect to Graph API
Try {
    Connect-MgGraph -TenantId $entraIdTenantId -ClientID $entraIdAppRegistrationAppId -CertificateThumbprint $entraIdAppRegistrationCertificate -NoWelcome
}
Catch {
    Write-Error "Error connecting via Graph API: $_"
    break
}

# Get group from Entra ID
Try {
    $entraIdGroup = Get-MgGroup -Filter "DisplayName eq '$entraIdGroupName'"
}
Catch {
    Write-Error "Error getting group from Entra ID: $_"
    break
}

# Get current Entra ID group members
Try {
    $entraIdGroupMembers = Get-MgGroupMember -GroupId $entraIdGroup.Id
}
Catch {
    Write-Error "Error getting group members from Entra ID: $_"
    break
}

# Get devices where the app is installed
Try {
    $intuneDetectedApps = Get-MgDeviceManagementDetectedApp -All -Filter "displayName eq '$applicationSearchString'"
    If ($null -eq $intuneDetectedApps) {
        $intuneDetectedApps = Get-MgDeviceManagementDetectedApp -All | Where-Object { $_.DisplayName -like $applicationSearchString }
    }

    # Check if current members still have the app installed and remove them from group if not
    ForEach ($entraIdGroupMember in $entraIdGroupMembers) {
        $searchDeviceInIntuneDeviceWithApp = $intuneDetectedApps | Where-Object { $_.DeviceName -eq $entraIdGroupMember.AdditionalProperties.DisplayName }
        If ($null -eq $searchDeviceInIntuneDeviceWithApp) {
            $entraIdDevice = $null
            $entraIdDevice = Get-MgDevice -Filter "displayname eq '$($entraIdGroupMember.AdditionalProperties.DisplayName)'"
            Remove-MgGroupMemberByRef -GroupId $entraIdGroup.Id -DirectoryObjectId $directoryObjectId
        }
    }

    # Add found devices to Entra ID group
    ForEach ($intuneDetectedApp in $intuneDetectedApps) {
        $intuneDeviceWithApp = $intuneDetectedApp.DeviceName
        $intuneDeviceIsInGroup = $entraIdGroupMembers | Where-Object { $_.AdditionalProperties.DisplayName -eq $intuneDeviceWithApp }
        If ($null -eq $intuneDeviceIsInGroup) {
            $entraIdDevice = $null
            $entraIdDevice = Get-MgDevice -Filter "displayname eq '$intuneDeviceWithApp'"
            New-MgGroupMember -GroupId $entraIdGroup.Id -DirectoryObjectId $entraIdDevice.Id
        }
    }
}
Catch {
    Write-Warning "Error getting devices where the app is installed from Intune: $_"
}

# Disconnect from Graph API
Try {
    Disconnect-MgGraph
}
Catch {
    Write-Error "Error disconnecting from Graph API: $_"
}