echo "VARIABLES"
echo "---------"
echo "MEMBERSHIP_NAME: ${MEMBERSHIP_NAME}"
echo "GKE_URI: ${GKE_URI}"
echo "---------"
echo ""
echo "continue (type '1' or '2')?"

select yn in "Yes" "No"
case $yn in

    Yes ) 

gcloud container hub memberships unregister $MEMBERSHIP_NAME \
   --gke-uri=$GKE_URI
break;;

    No ) 
    
break;;
esac




