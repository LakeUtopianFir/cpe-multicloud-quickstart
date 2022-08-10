echo "***********************"
echo "Setting Variables"
echo "***********************"
export gkeCluster=$VGKECLUSTER
export gcpRegion=$VGCPREGION
export gcpProject=$VGCPPROJECT
export NS=gws
export SERVICE=gws
export DOMAIN=$VDOMAIN
export IMAGE_REGISTRY=$VIMAGEREGISTRY
export ARTIFACT_REPO=$VARTIFACTREPO
export FULLCOMMAND=$VHELMCOMMAND
export pullsecret=$PULLSECRET
export JFROGUSR=$JFROGUSR
export JFROGPASS=$JFROGPASS
export POSTGRES_ADDR=$POSTGRES_ADDR        
export POSTGRES_USER=$POSTGRES_USER
export POSTGRES_PASSWORD=$POSTGRES_PASSWORD
export DB_NAME=$DB_NAME
export LOCATION=$LOCATION
export gws_ops_pass_encr=$gws_ops_pass_encr
export gws_ops_user=$gws_ops_user
export DB_NAME_PROV=$DB_NAME_PROV
export gws_client_id=$gws_client_id
export gws_client_secret=$gws_client_secret
export gws_pg_user=$gws_pg_user
export DB_NAME_GWS=$DB_NAME_GWS
export gws_app_provisioning=$gws_app_provisioning
export gws_app_workspace=$gws_app_workspace
export gws_as_pg_pass=$gws_as_pg_pass
export gws_as_pg_user=$gws_as_pg_user
export gws_pg_pass=$gws_pg_pass


echo "***********************"
echo "Logging into GCP"
echo "***********************"
gcloud init --no-launch-browser

echo "***********************"
echo "Logging into GKE"
echo "***********************"
gcloud container clusters get-credentials $gkeCluster --region $gcpRegion --project $gcpProject

echo "***********************"
echo "Create or use namespace"
echo "***********************"
if ! kubectl get namespaces $NS; then
    echo "Namespace $NS does not exist. Creating it.."
    kubectl create namespace $NS
else
    echo "Namespace $NS already exists. Will use it."
fi
kubectl config set-context --current --namespace=$NS

echo "********************"
echo "Creating Pull Secret"
echo "********************"
cat <<EOF | kubectl create -n $NS -f -
apiVersion: v1
kind: Secret
metadata:
  name: pullsecret
  namespace: $NS
data:
  .dockerconfigjson: >-
     $pullsecret
type: kubernetes.io/dockerconfigjson
EOF

echo $(kubectl get secrets pullsecret -n $NS)

echo "***********************"
echo "Creating K8 Secrets"
echo "***********************"
POSTGRES_PASSWORD=$(kubectl get secret --namespace infra pgdb-gws-postgresql -o jsonpath="{.data.postgres-password}" | base64 --decode)
echo "Collected Postgres Password"

gws_redis_password=$(kubectl get -n infra secrets infra-redis-redis-cluster -o jsonpath='{.data.redis-password}' | base64 --decode)
echo "Collected Redis Password"

gws_consul_token=$(kubectl get -n consul secrets consul-bootstrap-acl-token -o jsonpath='{.data.token}' | base64 --decode)
echo "Collected Consul ACL Token"

ES_ADDR=$(kubectl get svc -n gws | grep .*master-hl)
echo "Collected ElasticSearch Service: $ES_ADDR"

REDIS_ADDR=$(kubectl get svc -n infra | grep infra.*cluster-headless)
ehco "Collected Redis Address: $REDIS_ADDR"

echo "***********************"
echo "Creating GAUTH API Entry"
echo "***********************"
chmod +x ./services/$SERVICE/misc_apiclient.sh
./services/$SERVICE/misc_apiclient.sh apiclient add all $DOMAIN

echo "***********************"
echo "Creating GAUTH CCID Entrys"
echo "***********************"
chmod +x ./services/$SERVICE/misc_ccid.sh
./services/$SERVICE/misc_ccid.sh ccid 100 /USW2

echo "***********************"
echo "Creating GAUTH CORS Entry"
echo "***********************"
chmod +x ./services/$SERVICE/misc_cors.sh
./services/$SERVICE/misc_cors.sh cors 100 ixn-100 $LOCATION

echo "***********************"
echo "Run Helm Charts"
echo "***********************"
cd "./services/$SERVICE"
COMMAND=$(echo $FULLCOMMAND | cut -d' ' -f1)
if [[ "$FULLCOMMAND" == *" "* ]]; then
    CHART_NAME=$(echo $FULLCOMMAND | tr -s ' ' | cut -d' ' -f2)
    RL_NAME=$(echo $FULLCOMMAND | tr -s ' ' | cut -d' ' -f3)
fi

# FOR EVERY HELM CHART ############################################################
# ℹ️ Notice: in application folder should be exist subfolder with name in format: 
#      [0-9][0-9]_chart_chart-name 
# where chart-name is name of chart using to installing 
# and digits define the instalation order 
# The chart-name using in command:
#     helm install RELEASE-NAME helm-repo/chart-name
# ##################################################################################
for DIR in [0-9][0-9]_chart_*$CHART_NAME*/; do
    
    CHART=$([[ -d "$DIR" ]] && echo $DIR | sed 's/[0-9][0-9]_chart_//' | sed 's/\///')
    
    DIR=$(echo $DIR | sed 's/\///')
    
    # evaluate ENV variables
    envsubst < $DIR/override_values.yaml > overrides.yaml
    # 🖊️ (Optional) EDIT 1st line of chart.ver file with chart version number
    VER=$(head -n 1 $DIR/chart.ver)
    
    FLAGS="$ARTIFACT_REPO/$CHART --install --version=$VER -n $NS -f $(pwd)/overrides.yaml"
    
    case $COMMAND in
    install)
        echo "Installing..."
        CMD="upgrade"
        ;;
    uninstall)
        echo "Uninstalling..."
        CMD="uninstall"
        FLAGS=""
        ;;
    validate)
        echo "Validating..."
        CMD="upgrade"
        FLAGS+=" --dry-run"
        ;;
    *)
        echo "❌ Wrong command"
        exit 1
        ;;
    esac
    cd $DIR
    
    touch overrides.yaml
    [[ "$FLAGS" ]] && FLAGS+=" -f $(pwd)/overrides.yaml"
    
    # FOR EVERY HELM RELEASE###########################################################
    # ℹ️ Notice: in chart folder should be exist subfolder with name in format: 
    #      [0-9][0-9]_release_release-name 
    # where release-name is name of release using to installing 
    # and digits define the instalation order 
    # The release-name using in command:
    #     helm install release-name helm-repo/chart-name
    #
    # If you want to run some preparing script (for ex: init database, check conditions) 
    # before installing, place you code in pre-relese-script.sh in release subfolder
    #
    # If you want to run some post-installing script (for ex: validate something),
    # place you code in post-relese-script.sh in release subfolder
    # ##################################################################################
    for DIR_RL in [0-9][0-9]_release_*$RL_NAME*/; do
        RELEASE=$([[ -d "$DIR_RL" ]] && echo $DIR_RL | sed 's/[0-9][0-9]_release_//' | sed 's/\///')
        cd $DIR_RL
        # Run pre-release-script if exists
        [[ "$COMMAND" == "install" ]] && [[ -f "pre-release-script.sh" ]] \
            && source pre-release-script.sh
        cd ..
        # evaluate ENV variables
        envsubst < $DIR_RL/override_values.yaml > overrides.yaml
        echo "helm $CMD $RELEASE $FLAGS"
        [[ "$CMD" ]] && [[ "$CHART" ]] && [[ "$RELEASE" ]] && \
                    helm $CMD $RELEASE $FLAGS
        cd $DIR_RL
        # Run post-release-script if exists
        [[ "$COMMAND" == "install" ]] && [[ -f "post-release-script.sh" ]] \
            && source post-release-script.sh
        cd ..
    
    done
    cd ..
done