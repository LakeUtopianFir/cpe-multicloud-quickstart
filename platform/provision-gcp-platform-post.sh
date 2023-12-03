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
echo "Modifying 1-certs"
echo "***********************"
#INPUT: VGCPPROJECT
#INPUT: VGCPREGIONPRIMARY
#INPUT: VGKECLUSTER
#INPUT: VDOMAIN
#INPUT: VEMAILADDRESS
#INPUT: VSTORAGEBUCKET

sed -i "s#INSERT_VGCPPROJECT#$VGCPPROJECT#g" "./platform/terraform/3-gcp-posttasks/1-certs/main.tf"
sed -i "s#INSERT_VGCPREGIONPRIMARY#$VGCPREGIONPRIMARY#g" "./platform/terraform/3-gcp-posttasks/1-certs/main.tf"
sed -i "s#INSERT_VGKECLUSTER#$VGKECLUSTER#g" "./platform/terraform/3-gcp-posttasks/1-certs/main.tf"
sed -i "s#INSERT_VDOMAIN#$VDOMAIN#g" "./platform/terraform/3-gcp-posttasks/1-certs/main.tf"
sed -i "s#INSERT_VEMAILADDRESS#$VEMAILADDRESS#g" "./platform/terraform/3-gcp-posttasks/1-certs/main.tf"
sed -i "s#INSERT_VSTORAGEBUCKET#$VSTORAGEBUCKET#g" "./platform/terraform/3-gcp-posttasks/1-certs/main.tf"
cat "./platform/terraform/3-gcp-posttasks/1-certs/main.tf"

echo "***********************"
echo "Modifying 2-thirdparty"
echo "***********************"
#INPUT: VGCPPROJECT
#INPUT: VGCPREGIONPRIMARY
#INPUT: VGKECLUSTER
#INPUT: VSTORAGEBUCKET

sed -i "s#INSERT_VGCPPROJECT#$VGCPPROJECT#g" "./platform/terraform/3-gcp-posttasks/2-thirdparty/main.tf"
sed -i "s#INSERT_VGCPREGIONPRIMARY#$VGCPREGIONPRIMARY#g" "./platform/terraform/3-gcp-posttasks/2-thirdparty/main.tf"
sed -i "s#INSERT_VGKECLUSTER#$VGKECLUSTER#g" "./platform/terraform/3-gcp-posttasks/2-thirdparty/main.tf"
sed -i "s#INSERT_VDOMAIN#$VDOMAIN#g" "./platform/terraform/3-gcp-posttasks/2-thirdparty/main.tf"
sed -i "s#INSERT_VSTORAGEBUCKET#$VSTORAGEBUCKET#g" "./platform/terraform/3-gcp-posttasks/2-thirdparty/main.tf"
sed -i "s#INSERT_VDOMAIN#$VDOMAIN#g" "./platform/tfm/3-gcp-posttasks/2-third-party/prometheus-values.yaml"
cat "./platform/terraform/3-gcp-posttasks/2-thirdparty/main.tf"

echo "***********************"
echo "Modifying 3-consul-mssql"
echo "***********************"
#INPUT: VGKECLUSTER
#INPUT: VGCPREGIONPRIMARY
#INPUT: VGCPPROJECT

sed -i "s|INSERT_VGKECLUSTER|$VGKECLUSTER|g" "./platform/terraform/3-gcp-posttasks/3-consul-mssql/main.tf"
sed -i "s|INSERT_VGCPREGIONPRIMARY|$VGCPREGIONPRIMARY|g" "./platform/terraform/3-gcp-posttasks/3-consul-mssql/main.tf"
sed -i "s|INSERT_VGCPPROJECT|$VGCPPROJECT|g" "./platform/terraform/3-gcp-posttasks/3-consul-mssql/main.tf"
sed -i "s#INSERT_VSTORAGEBUCKET#$VSTORAGEBUCKET#g" "./platform/terraform/3-gcp-posttasks/3-consul-mssql/main.tf"
cat "./platform/terraform/3-gcp-posttasks/3-consul-mssql/main.tf"

echo "***********************"
echo "Modifying 4-pullsecret"
echo "***********************"
#INPUT: VGCPREGIONPRIMARY
#INPUT: VGCPPROJECT
#INPUT: VSTORAGEBUCKET
sed -i "s#INSERT_VGCPPROJECT#$VGCPPROJECT#g" "./platform/terraform/3-gcp-posttasks/4-pullsecret/main.tf"
sed -i "s#INSERT_VGCPREGIONPRIMARY#$VGCPREGIONPRIMARY#g" "./platform/terraform/3-gcp-posttasks/4-pullsecret/main.tf"
sed -i "s#INSERT_VSTORAGEBUCKET#$VSTORAGEBUCKET#g" "./platform/terraform/3-gcp-posttasks/4-pullsecret/main.tf"
cat "./platform/terraform/3-gcp-posttasks/4-pullsecret/main.tf"


echo "***********************"
echo "Modifying 5-gsp-storage-bucket"
echo "***********************"
#INPUT: VGCPREGIONPRIMARY
#INPUT: VGCPPROJECT
#INPUT: VSTORAGEBUCKET
#INPUT: VGSPSTORAGEBUCKET
sed -i "s#INSERT_VGCPPROJECT#$VGCPPROJECT#g" "./platform/terraform/3-gcp-posttasks/5-gsp-storage-bucket/main.tf"
sed -i "s#INSERT_VGCPREGIONPRIMARY#$VGCPREGIONPRIMARY#g" "./platform/terraform/3-gcp-posttasks/5-gsp-storage-bucket/main.tf"
sed -i "s#INSERT_VSTORAGEBUCKET#$VSTORAGEBUCKET#g" "./platform/terraform/3-gcp-posttasks/5-gsp-storage-bucket/main.tf"
sed -i "s#INSERT_VGSPSTORAGEBUCKET#$VGSPSTORAGEBUCKET#g" "./platform/terraform/3-gcp-posttasks/5-gsp-storage-bucket/main.tf"
cat "./platform/terraform/3-gcp-posttasks/5-gsp-storage-bucket/main.tf"

echo "***********************"
echo "Checking to see if GKE is in RUNNING status"
echo "***********************"
# A freshly deployed GKE cluster will usually have updates to apply to the nodes, etc. 
# While its online and usuable from a Kubernetes perspective, its not in a fully running state and enabling Filestore will fail. 
# Checking for status of the cluster and performing 10 minute waits and re checks. 

gkeClusterStatus=$(gcloud container clusters list --format="value(STATUS.scope())")
status="RUNNING"
if [ "$gkeClusterStatus" != "$status" ]
then
    until [ "$gkeClusterStatus" == "$status" ]
    do
    echo "GKE Cluster is not fully ready yet. Waiting 10 minutes to check again"
    sleep 10m
    gkeClusterStatus=$(gcloud container clusters list --format="value(STATUS.scope())")
    done
else
    echo "GKE Cluster is in a RUNNING state"
fi

echo "***********************"
echo "Provisioning 1-certs"
echo "***********************"
dir=platform/terraform/3-gcp-posttasks/1-certs

cd ${dir}   
env=${dir%*/}
env=${env#*/}  
terraform init || exit 1
terraform apply -auto-approve || exit 1

cd ../../../../

echo "***********************"
echo "Provisioning 2-thirdparty"
echo "***********************"
dir=platform/terraform/3-gcp-posttasks/2-thirdparty

cd ${dir}   
env=${dir%*/}
env=${env#*/}  
terraform init || exit 1
terraform apply -auto-approve || exit 1

cd ../../../../

#Get Consul bootstrap token and MSSQL SA password and export as TF VARs
export TF_VAR_consulsecret=$(kubectl get -n consul secrets consul-bootstrap-acl-token -o jsonpath='{.data.token}' | base64 --decode)
export TF_VAR_mssqlsapassword=$(kubectl get -n infra secrets mssql-mssqlserver-2019-secret -o jsonpath='{.data.sapassword}' | base64 --decode)

#Create tunnel to consul and mssql
kubectl port-forward svc/consul-server 8500:8500 -n consul > /dev/null 2>&1 &
kubectl port-forward svc/mssqlserver-2019 1433:1433 -n infra > /dev/null 2>&1 &

echo "***********************"
echo "Provisioning 3-consul-mssql"
echo "***********************"
dir=platform/terraform/3-gcp-posttasks/3-consul-mssql

cd ${dir}   
env=${dir%*/}
env=${env#*/}  
terraform init || exit 1
terraform apply -auto-approve || exit 1

cd ../../../../

echo "***********************"
echo "Provisioning 4-pullsecret"
echo "***********************"
dir=platform/terraform/3-gcp-posttasks/4-pullsecret

cd ${dir}   
env=${dir%*/}
env=${env#*/}  
terraform init || exit 1
terraform apply -auto-approve || exit 1

cd ../../../../

echo "***********************"
echo "Provisioning 5-gsp-storage-bucket"
echo "***********************"
dir=platform/terraform/3-gcp-posttasks/5-gsp-storage-bucket

cd ${dir}   
env=${dir%*/}
env=${env#*/}  
terraform init || exit 1
terraform apply -auto-approve || exit 1

cd ../../../../

echo "***********************"
echo "Enable Filestore"
echo "***********************"
# A freshly deployed GKE cluster will usually have updates to apply to the nodes, etc. 
# While its online and usuable from a Kubernetes perspective, its not in a fully running state and enabling Filestore will fail. 
# Checking for status of the cluster and performing 10 minute waits and re checks. 

gkeClusterStatus=$(gcloud container clusters list --format="value(STATUS.scope())")
status="RUNNING"

if [ "$gkeClusterStatus" != "$status" ]
then
    until ["$gkeClusterStatus" == "$status" ]
    do
    echo "GKE Cluster is not fully ready yet. Waiting 10 minutes to check again"
    sleep 10m
    gkeClusterStatus=$(gcloud container clusters list --format="value(STATUS.scope())")
    done
else
    echo "GKE Cluster is in a RUNNING state"
fi

echo "Enable Filestore CSI driver...this can take over an hour to enable"
gcloud container clusters update $VGKECLUSTER --update-addons=GcpFilestoreCsiDriver=ENABLED --region=$VGCPREGIONPRIMARY

echo "***********************"
echo "Set Consul Stub Zone in Kube-DNS"
echo "***********************"
CONSULDNS=$(kubectl get svc consul-dns -n consul -o jsonpath='{.spec.clusterIP}')
sed -i "s#INSERT_CONSULDNS#$CONSULDNS#g" "./platform/kube-dns-patch.yaml"
kubectl patch configmap/kube-dns -n kube-system --type merge --patch-file ./platform/kube-dns-patch.yaml