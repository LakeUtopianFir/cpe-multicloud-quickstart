echo "***********************"
echo "Modifying 9-repo"
echo "***********************"
#INPUT: VGCPPROJECT
#INPUT: VGCPREGION
#INPUT: VGCPREPOID
#VARIABLE: REPOEXISTS - computed
#INPUT: REMOTEREPO"
#INPUT: REMOTEREPOUID"
#INPUT: REMOTEREPOPWD"

#Check if repo already exists - 0 is yes or 1 if no
gcloud artifacts repositories describe $VGCPREPOID --location=$VGCPREGIONPRIMARY --project=$VGCPPROJECT
REPOEXISTS=$?

sed -i "s#INSERT_VGCPPROJECT#$VGCPPROJECT#g" "./platform/terraform/cloudbuild/9-repo/main.tf"
sed -i "s#INSERT_VGCPREGIONPRIMARY#$VGCPREGIONPRIMARY#g" "./platform/terraform/cloudbuild/9-repo/main.tf"
sed -i "s#INSERT_VGCPREPOID#$VGCPREPOID#g" "./platform/terraform/cloudbuild/9-repo/main.tf"
sed -i "s#INSERT_REPOEXISTS#$REPOEXISTS#g" "./platform/terraform/cloudbuild/9-repo/main.tf"
sed -i "s#INSERT_REMOTEREPO#$REMOTEREPO#g" "./platform/terraform/cloudbuild/9-repo/main.tf"
sed -i "s#INSERT_REMOTEHELM#$REMOTEHELM#g" "./platform/terraform/cloudbuild/9-repo/main.tf"
sed -i "s#INSERT_REMOTEUSER#$REMOTEUSER#g" "./platform/terraform/cloudbuild/9-repo/main.tf"
sed -i "s#INSERT_REMOTEPASS#$REMOTEPASS#g" "./platform/terraform/cloudbuild/9-repo/main.tf"
cat "./platform/terraform/cloudbuild/9-repo/main.tf"

dir=platform/terraform/cloudbuild/9-repo/

echo "***********************"
echo "Initializing Terraform to provision GCP Artifactory"
echo "***********************"
#for dir in platform/terraform/cloudbuild/*
#do 
    cd ${dir}   
    env=${dir%*/}
    env=${env#*/}  
    echo ""
    echo "*************** TERRAFOM PLAN ******************"
    echo "******* At environment: ${env} ********"
    echo "*************************************************"
    terraform init || exit 1
    cd ../../../../
#done

echo "***********************"
echo "Executing Terraform to provision GCP Artifactory"
echo "***********************"
#for dir in platform/terraform/cloudbuild/*
#do 
    cd ${dir}   
    env=${dir%*/}
    env=${env#*/}  
    echo ""
    echo "*************** TERRAFOM PLAN ******************"
    echo "******* At environment: ${env} ********"
    echo "*************************************************"
    terraform apply -auto-approve -parallelism=1 || exit 1
    cd ../../../../
#done