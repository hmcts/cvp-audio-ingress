env=$1
groups=$(az group list --subscription dts-sharedservices-${env} --query  "[?name=='cvp-recordings-${env}-rg'].{Name:name}")

if [[ "${groups[@]}" == "[]" ]]; then
    #if the resource group doesn't exist, output false
    echo "##vso[task.setvariable variable=resource_group_exists;isOutput=true]false"
else
    #if the resource group does exist, output true
    echo "##vso[task.setvariable variable=resource_group_exists;isOutput=true]true"
fi