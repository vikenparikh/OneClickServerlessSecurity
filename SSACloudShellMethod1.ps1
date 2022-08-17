#Exit Script on error
$ErrorActionPreference = "Stop"
$WarningPrefBackup = $WarningPreference
$WarningPreference = 'SilentlyContinue'

# Describe to the User what that Script does
Write-Host "This is a Script to enable or disable ServerlessSecurity Plugin for Functions within a Subscription"

# Prompt Customer to enter the subscription_id and set it to a context
$selected_subscription_id = Read-Host -Prompt "`n Enter the subscription_id you would like to enable/disable the ServerlessSecurity agent for"
Write-Host "Selected Subscription ID is: $selected_subscription_id"
Set-AzContext -Subscription $selected_subscription_id

$PolicyName = "DefenderForServerless"
$PolicyScope = "/subscriptions/$($selected_subscription_id)"

# For each function from $function_app_list, 
# set AZURE_FUNCTIONS_SECURITY_AGENT_ENABLED to 1 to enable the agent.
# remove AZURE_FUNCTIONS_SECURITY_AGENT_ENABLED to disable the agent.
$toggle_option = Read-Host -Prompt "`n Enter 0 to Disable, 1 to Enable, any other input will do nothing and exit.`n Note: enablement/disablement of the defender will result in function restart...."

Write-Host "Please wait while deployment is complete..."
# Get all functions within the subscription
$function_app_list = Get-AzFunctionApp -SubscriptionId $selected_subscription_id | Out-Null

switch ($toggle_option) {

    # Remove Configuration Switch to Disable
    0 {
        For ($Cntr = 0 ; $Cntr -lt $($function_app_list.Count); $Cntr++) {
            Remove-AzFunctionAppSetting -Name $function_app_list[$Cntr].Name -ResourceGroupName $function_app_list[$Cntr].ResourceGroupName -AppSettingName "AZURE_FUNCTIONS_SECURITY_AGENT_ENABLED" | Out-Null
        };
        Write-Host "Disabled AZURE_FUNCTIONS_SECURITY_AGENT for Subscription ID is: $selected_subscription_id"
        Remove-AzPolicyAssignment -Name $PolicyName -Scope $PolicyScope
        Remove-AzPolicyDefinition -Name $PolicyName -Force
        break
    }

    # Update Configuration to Enable
    1 { 
        # Update Policies
        Register-AzResourceProvider -ProviderNamespace 'Microsoft.PolicyInsights' | Out-Null
        $PolicyDescription = "Policy to deploy resources required to enable the Defender for Serverless product"
        $PolicyDefinition = New-AzPolicyDefinition -Name $PolicyName -Policy Policy.json -Description $PolicyDescription | Out-Null
        $PolicyAssignment = New-AzPolicyAssignment -Name $PolicyName -Description $PolicyDescription -Scope $PolicyScope -PolicyDefinition $PolicyDefinition -IdentityType SystemAssigned -Location westus2 | Out-Null
        Start-AzPolicyRemediation -PolicyAssignmentId $PolicyAssignment.ResourceId -Name $PolicyName -ParallelDeploymentCount 1 -ResourceDiscoveryMode ReEvaluateCompliance | Out-Null

        For ($Cntr = 0 ; $Cntr -lt $($function_app_list.Count); $Cntr++) {
            Update-AzFunctionAppSetting -Name $function_app_list[$Cntr].Name -ResourceGroupName $function_app_list[$Cntr].ResourceGroupName -AppSetting @{"AZURE_FUNCTIONS_SECURITY_AGENT_ENABLED" = "1" } | Out-Null
        }; Write-Host "Enabled AZURE_FUNCTIONS_SECURITY_AGENT for Subscription ID is: $selected_subscription_id"; break 
    }

    # Defaults to break the switch, without any changes made
    default { break }
}

# Reset preference
$WarningPreference = $WarningPrefBackup