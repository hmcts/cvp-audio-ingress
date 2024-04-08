env=$1
subscription=$(echo "dts-sharedservices-${env}")
echo $subscription
groups=$(az group list --subscription $subscription --query  "[?name=='cvp-recordings-${env}-rg'].{Name:name}")

if [[ "${groups[@]}" == "[]" ]]; then
    #if the resource group doesn't exist, output false
    echo "##vso[task.setvariable variable=resource_group_exists;isOutput=true]false"
    echo "Resource group was not found"
else
    #if the resource group does exist, output true
    echo "##vso[task.setvariable variable=resource_group_exists;isOutput=true]true"
    echo "Resource group exists"
fi