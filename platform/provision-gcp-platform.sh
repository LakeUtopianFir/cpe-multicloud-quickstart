echo "***********************"
echo "Modifying Terraform Files for user variables and inputs"
echo "***********************"
#ALL UNIQUE INPUTS
#INPUT: VGCPPROJECT
#INPUT: VGCPREGIONPRIMARY
#INPUT: VGCPREGIONSECONDARY
#INPUT: VDOMAIN
#INPUT: VGKECLUSTER
#INPUT: VEMAILADDRESS
#INPUT: VSTORAGEBUCKET

echo "***********************"
echo "Modifying 1-network"
echo "***********************"
#INPUT: VGCPPROJECT
#INPUT: VGCPREGIONPRIMARY
#INPUT: VGCPREGIONSECONDARY
#INPUT: VDOMAIN
#INPUT: VSTORAGEBUCKET

sed -i "s#INSERT_VGCPPROJECT#$VGCPPROJECT#g" "./platform/terraform/2-gcp/1-network/main.tf"
sed -i "s#INSERT_VGCPREGIONPRIMARY#$VGCPREGIONPRIMARY#g" "./platform/terraform/2-gcp/1-network/main.tf"
sed -i "s#INSERT_VGCPREGIONSECONDARY#$VGCPREGIONSECONDARY#g" "./platform/terraform/2-gcp/1-network/main.tf"
sed -i "s#INSERT_VDOMAIN#$VDOMAIN#g" "./platform/terraform/2-gcp/1-network/main.tf"
sed -i "s#INSERT_VSTORAGEBUCKET#$VSTORAGEBUCKET#g" "./platform/terraform/2-gcp/1-network/main.tf"
cat "./platform/terraform/2-gcp/1-network/main.tf"

echo "***********************"
echo "Modifying 2-gke-cluster"
echo "***********************"
#INPUT: VGCPPROJECT
#INPUT: VGCPREGIONPRIMARY
#INPUT: VGKECLUSTER
#INPUT: VSTORAGEBUCKET

sed -i "s#INSERT_VGCPPROJECT#$VGCPPROJECT#g" "./platform/terraform/2-gcp/2-gke-cluster/main.tf"
sed -i "s#INSERT_VGCPREGIONPRIMARY#$VGCPREGIONPRIMARY#g" "./platform/terraform/2-gcp/2-gke-cluster/main.tf"
sed -i "s#INSERT_VGKECLUSTER#$VGKECLUSTER#g" "./platform/terraform/2-gcp/2-gke-cluster/main.tf"
sed -i "s#INSERT_VSTORAGEBUCKET#$VSTORAGEBUCKET#g" "./platform/terraform/2-gcp/2-gke-cluster/main.tf"
cat "./platform/terraform/2-gcp/2-gke-cluster/main.tf"

echo "***********************"
echo "Modifying 3-k8s-setup"
echo "***********************"
#INPUT: VGCPPROJECT
#INPUT: VGCPREGIONPRIMARY
#INPUT: VGKECLUSTER
#INPUT: VSTORAGEBUCKET

sed -i "s#INSERT_VGCPPROJECT#$VGCPPROJECT#g" "./platform/terraform/2-gcp/3-k8s-setup/main.tf"
sed -i "s#INSERT_VGCPREGIONPRIMARY#$VGCPREGIONPRIMARY#g" "./platform/terraform/2-gcp/3-k8s-setup/main.tf"
sed -i "s#INSERT_VGKECLUSTER#$VGKECLUSTER#g" "./platform/terraform/2-gcp/3-k8s-setup/main.tf"
sed -i "s#INSERT_VSTORAGEBUCKET#$VSTORAGEBUCKET#g" "./platform/terraform/2-gcp/3-k8s-setup/main.tf"
cat "./platform/terraform/2-gcp/3-k8s-setup/main.tf"


echo "***********************"
echo "Initializing Terraform to provision GCP Platform"
echo "***********************"
for dir in platform/terraform/2-gcp/*
do 
    cd ${dir}   
    env=${dir%*/}
    env=${env#*/}  
    echo ""
    echo "*************** TERRAFOM PLAN ******************"
    echo "******* At environment: ${env} ********"
    echo "*************************************************"
    terraform init || exit 1
    cd ../../../../
done

echo "***********************"
echo "Executing Terraform to provision GCP Platform"
echo "***********************"
for dir in platform/terraform/2-gcp/*
do 
    cd ${dir}   
    env=${dir%*/}
    env=${env#*/}  
    echo ""
    echo "*************** TERRAFOM PLAN ******************"
    echo "******* At environment: ${env} ********"
    echo "*************************************************"
    terraform apply -auto-approve || exit 1
    cd ../../../../
done