To deploy a new version of the vm extensions, few steps are required:
- generate zip file and upload it to the storage account
- generate the `deploy{os}.json` file with the right version, media link and region 
- run the deploy command from the Azure CLI
    
        New-AzResourceGroupDeployment -ResourceGroupName {resource group} -TemplateFile "deploy{os}.json" -Verbose