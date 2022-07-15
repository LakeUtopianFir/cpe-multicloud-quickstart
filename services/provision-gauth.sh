echo "***********************"
echo "Logging into GCP"
echo "***********************"
gcloud init --no-launch-browser

echo "***********************"
echo "Logging into GKE"
echo "***********************"
gcloud container clusters get-credentials cluster03 --region us-west2 --project gts-multicloud-pe-dev2

echo "***********************"
echo "Create or use namespace"
echo "***********************"
NS=gauth
if ! kubectl get namespaces $NS; then
    echo "Namespace $NS does not exist. Creating it.."
    kubectl create namespace $NS
else
    echo "Namespace $NS already exists. Will use it."
fi
kubectl config set-context --current --namespace=gauth

echo "***********************"
echo "Creating JKS Keystore"
echo "***********************"
keytool -keystore jksStorage.jks -genkey -noprompt -alias gws-auth-key -dname "CN=cluster03.gcp.demo.genesys.com, O=Genesys, L=Indianapolis, S=Indiana, C=US" -storepass Genesys1234 -keypass Genesys1234 -keyalg RSA
JKSBASE64=$(cat ./jksStorage.jks | base64 -w 0)
sed -i "s#JKS_KEY_CONTENT#$JKSBASE64#g" "./services/gauth/01_chart_gauth/override_values.yaml"
sed -i "s#JKS_KEY_CONTENT#$JKSBASE64#g" "./services/gauth/01_chart_gauth/01_release_gauth/override_values.yaml"
echo $JKSBASE64
cat "./services/gauth/01_chart_gauth/override_values.yaml"

echo "***********************"
echo "Creating K8 Secrets"
echo "***********************"
REDISPASSWORD=$(kubectl get -n infra secrets infra-redis-redis-cluster -o jsonpath='{.data.redis-password}' | base64 --decode)
sed -i "s|INSERT_REDIS_PASSWORD|$REDISPASSWORD|g" "./services/gauth/gauth-k8secrets.yaml"

POSTGRESPASSWORD=$(kubectl get secret --namespace infra pgdb-gws-postgresql -o jsonpath="{.data.postgres-password}" | base64 --decode)
sed -i "s|INSERT_POSTGRES_PASSWORD|$POSTGRESPASSWORD|g" "./services/gauth/gauth-k8secrets.yaml"

cat "./services/gauth/gauth-k8secrets.yaml"

kubectl apply -f  ./services/gauth/gauth-k8secrets.yaml

echo "***********************"
echo "Run Helm Charts"
echo "***********************"
export NS=gauth
export SERVICE=gauth
export DOMAIN=cluster03.gcp.demo.genesys.com
export IMAGE_REGISTRY=gcr.io/gts-multicloud-pe-dev/gts-multicloud-pe
export ARTIFACT_REPO=oci://us-west2-docker.pkg.dev/gts-multicloud-pe-dev/gts-multicloud-pe
export FULLCOMMAND=install

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