KSA_NAME=user-id-ksa
VIEW_BINDING_NAME=view-binding-role-name
NODE_READER_BINDING_NAME=node-reader-binding-role-name
CLUSTER_ADMIN_BINDING_NAME=admin-binding-role-name

echo "VARIABLES"
echo "---------"
echo "KSA_NAME: ${KSA_NAME}"
echo "VIEW_BINDING_NAME: ${VIEW_BINDING_NAME}"
echo "NODE_READER_BINDING_NAME: ${NODE_READER_BINDING_NAME}"
echo "CLUSTER_ADMIN_BINDING_NAME: ${CLUSTER_ADMIN_BINDING_NAME}"
echo "---------"
echo ""
echo "continue (type '1' or '2')?"

select yn in "Yes" "No"
case $yn in

    Yes ) 

kubectl apply -f node-reader.yaml

kubectl create serviceaccount $KSA_NAME

kubectl create clusterrolebinding $VIEW_BINDING_NAME \
--clusterrole view --serviceaccount default:$KSA_NAME

kubectl create clusterrolebinding $NODE_READER_BINDING_NAME \
--clusterrole node-reader --serviceaccount default:$KSA_NAME

kubectl create clusterrolebinding $CLUSTER_ADMIN_BINDING_NAME \
--clusterrole cluster-admin --serviceaccount default:$KSA_NAME

SECRET_NAME=$(kubectl get serviceaccount $KSA_NAME -o jsonpath='{$.secrets[0].name}')
kubectl get secret ${SECRET_NAME} -o jsonpath='{$.data.token}' | base64 -d

break;;

    No ) 
    
break;;
esac

