echo "***********************"
echo "Set Variables"
echo "***********************"
export gkeCluster=$VGKECLUSTER
export gcpRegion=$VGCPREGIONPRIMARY
export gcpProject=$VGCPPROJECT

echo "***********************"
echo "Logging into GCP"
echo "***********************"
gcloud init --no-launch-browser

echo "***********************"
echo "Logging into GKE"
echo "***********************"
gcloud container clusters get-credentials $gkeCluster --region $gcpRegion --project $gcpProject


echo "***********************"
echo "Modifying 10-misc"
echo "***********************"
#INPUT: VGCPPROJECT

#Get Consul bootstrap token
CONSULSECRET=$(kubectl get -n consul secrets consul-bootstrap-acl-token -o jsonpath='{.data.token}' | base64 --decode)
#Create tunnel to consul
kubectl port-forward svc/consul-server 8500:8500 -n consul > /dev/null 2>&1 &
sed -i "s|INSERT_CONSUL_TOKEN|$CONSULSECRET|g" "./platform/terraform/cloudbuild/10-misc/main.tf"
sed -i "s|INSERT_VGKECLUSTER|$VGKECLUSTER|g" "./platform/terraform/cloudbuild/10-misc/main.tf"
sed -i "s|INSERT_VGCPREGIONPRIMARY|$VGCPREGIONPRIMARY|g" "./platform/terraform/cloudbuild/10-misc/main.tf"
sed -i "s|INSERT_VGCPPROJECT|$VGCPPROJECT|g" "./platform/terraform/cloudbuild/10-misc/main.tf"
cat "./platform/terraform/cloudbuild/10-misc/main.tf"

dir=platform/terraform/cloudbuild/10-misc/

echo "***********************"
echo "Initializing Terraform to provision GKE misc settings"
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
    terraform apply -auto-approve || exit 1
    cd ../../../../
#done