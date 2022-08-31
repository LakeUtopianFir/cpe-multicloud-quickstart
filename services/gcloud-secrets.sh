echo "***********************"
echo "Set variables"
echo "***********************"
export gkeCluster=$VGKECLUSTER
export gcpRegion=$VGCPREGION
export gcpProject=$VGCPPROJECT
export NS=gauth
export SERVICE=gauth
export DOMAIN=$VDOMAIN
export IMAGE_REGISTRY=$VIMAGEREGISTRY
export ARTIFACT_REPO=$VARTIFACTREPO
export FULLCOMMAND=$VHELMCOMMAND

echo "***********************"
echo "Logging into GCP"
echo "***********************"
gcloud init --no-launch-browser

echo "***********************"
echo "Logging into GKE"
echo "***********************"
gcloud container clusters get-credentials $gkeCluster --region $gcpRegion --project $gcpProject

#### Run gcloud commands
echo 'running gcloud secret'
secret1=$(gcloud secrets versions access 1 --secret="auth-deployment-secret-gke3-2")
echo $secret1 > deployment-secrets.json
cat deployment-secrets.json

echo "****************************"
echo "creating deployment-secrets"
echo "****************************"
kubectl create -f deployment-secrets.json -n $SERVICE
echo "****************************"
echo "Validating deployemnt secrets exist"
echo "****************************"
kubectl describe secret deployment-secret -n $SERVICE
echo "#### END #####"