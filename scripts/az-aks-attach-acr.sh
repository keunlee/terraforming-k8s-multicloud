echo "VARIABLES"
echo "---------"
echo "AZURE_RG: ${AZURE_RG}"
echo "ACR: ${ACR}"
echo "AKS_CLUSTER: ${AKS_CLUSTER}"
echo "---------"
echo ""
echo "continue (type '1' or '2')?"

select yn in "Yes" "No"
case $yn in

    Yes ) 

az aks update -n $AKS_CLUSTER -g $AZURE_RG --attach-acr $ACR
break;;

    No ) 
    
break;;
esac




