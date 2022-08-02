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

#Get Consul bootstrap token and MSSQL SA password and export as TF VARs
export TF_VAR_consulsecret=$(kubectl get -n consul secrets consul-bootstrap-acl-token -o jsonpath='{.data.token}' | base64 --decode)
export TF_VAR_mssqlsapassword=$(kubectl get -n infra secrets mssql-mssqlserver-2019-secret -o jsonpath='{.data.sapassword}' | base64 --decode)

#Create tunnel to consul and mssql
kubectl port-forward svc/consul-server 8500:8500 -n consul > /dev/null 2>&1 &
kubectl port-forward svc/mssqlserver-2019 1433:1433 -n infra > /dev/null 2>&1 &

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
cat "./platform/terraform/3-gcp-posttasks/3-consul-mssql/main.tf"

echo "***********************"
echo "Initializing Terraform to provision GKE misc settings"
echo "***********************"
for dir in platform/terraform/3-gcp-posttasks/*
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
echo "Executing Terraform to provision GKE misc settings"
echo "***********************"
for dir in platform/terraform/3-gcp-posttasks/*
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

echo "***********************"
echo "Enable Filestore"
echo "***********************"
# A freshly deployed GKE cluster will usually have updates to apply to the nodes, etc. 
# While its online and usuable from a Kubernetes perspective, its not in a fully running state and enabling Filestore will fail. 
# Checking for status of the cluster and performing 10 minute waits and re checks. 

gkeClusterStatus=$(gcloud container clusters list --format="value(STATUS.scope())")
if [echo $gkeClusterStatus != "RUNNING"]
then
    until [ echo $gkeClusterStatus == "RUNNING" ]
    do
    echo "GKE Cluster is not fully ready yet. Waiting 10 minutes to check again"
    sleep 10m
    gkeClusterStatus=$(gcloud container clusters list --format="value(STATUS.scope())")
    done
fi

gcloud container clusters update $VGKECLUSTER --update-addons=GcpFilestoreCsiDriver=ENABLED --region=$VGCPREGIONPRIMARY

echo "***********************"
echo "Set Consul Stub Zone in Kube-DNS"
echo "***********************"
CONSULDNS=$(kubectl get svc consul-dns -n consul -o jsonpath='{.spec.clusterIP}')
sed -i "s#INSERT_CONSULDNS#$CONSULDNS#g" "./services/$SERVICE/kube-dns-patch.yaml"
kubectl patch configmap/kube-dns -n kube-system --type merge --patch-file ./services/$SERVICE/kube-dns-patch.yaml