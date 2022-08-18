# Enable - Disable serverless security
*This Script allows a customer to enable or remove ServerlessSecurity Agent*

***Please note : The function apps will restart during enabling or disabling the agent***

# Method 1

1) Open Cloudshell and Run the command to dowload script to cloudshell
```
curl -LO "https://raw.githubusercontent.com/vikenparikh/OneClickServerlessSecurity/main/SSACloudShellMethod1.ps1"
```

2) Run the script by using the command on cloudshell
```
./CloudShellMethod1.ps1
```

3) Copy the SubscriptionId for the subscription you want to change and insert it when prompted by the script

4) Then enter 0 to Disable, 1 to Enable the ServerlessSecurity Agent 

5) Only For Enabling  the ServerlessSecurity Agent, enter the provided secure key and wait till the deployment completes.

5) Check for Success - Check if the script run was successful without any errors

# Method 2

## Prerequisites : 

1) Create a User assigned managed Identity for the subscription - [link](https://ms.portal.azure.com/#create/Microsoft.ManagedIdentity]
Or use an existing one if it exists - [link](https://ms.portal.azure.com/#view/HubsExtension/BrowseResource/resourceType/Microsoft.ManagedIdentity%2FuserAssignedIdentities)

2) Check if the managed idenity has appropriate role permissions for the subscription - Navigate to Azure role assignments

3) Copy the Id of the Managed Identity - Go to Properties from the menu on the left - 
It will be of the format - /subscriptions/{subid}/resourcegroups/{res-group-id}/providers/Microsoft.ManagedIdentity/userAssignedIdentities/{managed-id}

## To enable or disable the script :

1) User to click enable to enable ServerlessSecurity / User to click disable to disable ServerlessSecurity

>[![EnableServerlessSecurity](https://img.shields.io/static/v1?label=enable&message=ServerlessSecurity&color=green)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fvikenparikh%2FOneClickServerlessSecurity%2Fmain%2FenableTemplate.json)

>[![DisableServerlessSecurity](https://img.shields.io/static/v1?label=disable&message=ServerlessSecurity&color=red)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fvikenparikh%2FOneClickServerlessSecurity%2Fmain%2FdisableTemplate.json)

2) Select the subscription you would like to enable/disable ServerlessSecurity

3) Select the Resource group with the managed Identity that have permission to modify the subscription

4) Paste the Id of the Managed Identity that you found in the Properties

5) Click Review+Create -> Create

6) The user will have to wait for the deploynment to finish, upon successul,
the user can see ServerlessSecurity enabled / disabled.

7) Check for Success - Check if the deployment was successful 
