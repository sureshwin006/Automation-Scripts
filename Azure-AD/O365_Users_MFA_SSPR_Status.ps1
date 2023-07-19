Connect-MsolService  
$users = Get-msoluser -All | where {("$($_.Licenses.AccountSkuID)" -ne "contactuscomm:STREAM" -and "$($_.Licenses.AccountSkuID)" -ne "contactuscomm:FLOW_FREE" -and $_.IsLicensed -eq $true -and $_.BlockCredential -eq $False) }  

$users | select DisplayName,
                @{N='Email';E={$_.UserPrincipalName}},
                @{N='IsLicensed';E={ IF ($_.IsLicensed -eq 'TRUE'){ ‘Yes’} Else {‘No’}}},
                BlockCredential,
                LastPasswordChangeTimestamp,
                LicenseReconciliationNeeded,
                @{N='Licenses';E={(($_.Licenses).AccountSkuId)}},
                OverallProvisioningStatus,
                Title,
                ValidationStatus,
                @{N='MFA-Methods';E={($_.StrongAuthenticationMethods | where isdefault -eq 'true').MethodType}},@{N='MFA_Requirements';E={($_.StrongAuthenticationRequirements).state}},@{N='AuthenticationType';E={($_.StrongAuthenticationPhoneAppDetails).AuthenticationType}},@{N='DeviceName';E={($_.StrongAuthenticationPhoneAppDetails).DeviceName}},@{N='NotificationType';E={($_.StrongAuthenticationPhoneAppDetails).NotificationType}},@{N='OathTokenTimeDrift';E={($_.StrongAuthenticationPhoneAppDetails).OathTokenTimeDrift}},@{N='AlternativePhoneNumber';E={($_.StrongAuthenticationUserDetails).AlternativePhoneNumber}},@{N='AlternativeEmail';E={($_.StrongAuthenticationUserDetails).Email}},@{N='PhoneNumber';E={($_.StrongAuthenticationUserDetails).PhoneNumber}} | Export-Csv 'C:\New folder\MFA_SSPR_info.csv'