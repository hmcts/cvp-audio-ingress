# CVP Audio Ingress
## Deploys the CVP audio only ingress platform

This project is a tactical solution to provide audio recordings for online hearings. The project has been expedited due
to the Covid-19 outbreak and as such the design and implementation is subject to change in the future.

The main solution consists of 2 active-active loadbalanced Linux VMs running Wowza Streaming Engine which then 
store the audio output in Azure Blob Storage. 

## Environments

The project can be deployed to the following 3 environments:

* Shared Services Sandbox - Used for dev work
* Shared Services Staging - Used as a pre-prod type environment and for end-to-end/load testing
* Shared Services Production

## Pipeline
There are two pipelines for CVP, with one for deployment and a nightly run for automated tasks.

**CVP Release Pipeline**
https://dev.azure.com/hmcts/Shared%20Services/_build?definitionId=337

This will Plan, Apply and Test sbox and stg environments in order. Afterwards it will run the Plan stage for the prod environment. Aproval is required prior to Apply stage in 'stg' environment.

**Path to Live**
To apply changes to prod environment, a release branch beginning with 'release' is created from main. This release branch will only run the Plan, Apply and Test stages in the prod environment. Similar to the 'stg' environment, approval is required prior to Apply stage.

This will Plan, Apply and Test each environment in order with approval at each stage.

**CVP Nightly Pipeline**
https://dev.azure.com/hmcts/Shared%20Services/_build?definitionId=498

This will run plan check for each environment, security/version checks and automated certificate renewal.

## Testing
There are some local development testing you can do and then there are some remote testing you can do.

*You cannot remote test Sandbox due to the networking setup we cannot get access, so all testing is done on Staging.

### Terraform Testing
You can run the plan command from your local by running the PowerShell command in `test/tf-plan.ps1`

This will generate a plan against the remote state file.

### Remote Testing

Please follow this guide to do remote testing of the streaming system.

https://tools.hmcts.net/confluence/display/VIH/Test+CVP+from+local

### Load Testing

*This has not been relooked at since the previous team and therefore might not be working.

Load testing can be conducted on a Windows VM on Azure (Standard DS11 v2). It will require dotnet core installing on it.
Once installed you can download, build and run from this project: 
[https://github.com/hmcts/vh-performance-wowza](https://github.com/hmcts/vh-performance-wowza)

### End to End testing
You will require your own Virtual Meetin Room from Kinly to test with. The Staging environment should be used for testing 
and has their Dev environment IPs whitelisted already.

## Known issues
* The Wowza Engine Management UI doesn't seem to work when the Wowza Engine is configured with TLS (which this project is).
* Occasionally cloud-init will not complete properly. The quickest solution seems to be to reboot the VM to trigger cloud-init to run again.

## Debugging

### Extensions Failure
https://tools.hmcts.net/confluence/display/VIH/Debug+Extensions

### Wowza not running

These are something that can be check for why the Wowza Streaming Service is not working.

#### Service Status

```Bash
sudo service WowzaStreamingEngine status
```

#### General logs
```Bash
cat /usr/local/WowzaStreamingEngine/logs/wowzastreamingengine_access.log
```
#### Error logs
```Bash
cat /usr/local/WowzaStreamingEngine/logs/wowzastreamingengine_error.log
```
old logs are in the same folder but with the date appended


#### Certificates

You can check if there is certificates installed and if they are valid

1. Get password via: 
```Bash
jksPass=$(cat /usr/local/WowzaStreamingEngine/conf/Server.xml | grep KeyStorePassword)
jksPass="${jksPass//<KeyStorePassword>/}"
jksPass="${jksPass//<\/KeyStorePassword>/}"
echo $jksPass
```
2. Run below and add password.
```Bash
export PATH=$PATH:/usr/local/WowzaStreamingEngine/java/bin
keytool -list -v -keystore /usr/local/WowzaStreamingEngine/conf/ssl.wowza.jks -storepass $jksPass
```
More details about CVP Certificates are here https://tools.hmcts.net/confluence/display/VIH/SSL+Certificates

### Accepting Wowza Terms & Conditions in Marketplace

For each Subscription, you will need to accept the Terms and Conditions for each Wowza VM on the Marketplace. If you need to accept the Terms & Conditions, you can add in the following task to the Apply step, after Terraform init:

```
- task: AzureCLI@2
    displayName: Accept Terms of Wowza VM in Marketplace
    inputs:
      azureSubscription: '${{ parameters.subscriptionName }}'
      scriptType: 'bash'
      scriptLocation: 'inlineScript'
      inlineScript: |
        az vm image terms accept --urn ${{ parameters.wowza_publisher }}:${{ parameters.wowza_offer }}:${{ parameters.wowza_sku }}:${{ parameters.wowza_version }}
```

### **Resolution**

Most things can be fixed with either a restart or by running `sudo /home/wowza/runcmd.sh` on the Virtual Machine, which will check and reinstall all missing components.