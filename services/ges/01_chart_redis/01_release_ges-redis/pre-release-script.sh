###############################################################################
# Because of using helm-repo as private repository  in gh-workflow,
# we have to redefine it for installing from public ones 
###############################################################################

# Then replace helm_repo to bitnami
helm repo add --force-update helm_repo https://charts.bitnami.com/bitnami
helm repo update

###############################################################################
# All secrets sould be saved in secrets: deployment-secrets
# 								Using it! 
# We extract secrets to environment variables. It will evaluate variables in
# override values by workflow.
###############################################################################
function get_secret {
	# Using: get_secret secret_name
	echo $( kubectl get secrets deployment-secrets -o custom-columns=:data.$1 \
			--no-headers | base64 -d )
}

###############################################################################
#       Install standalone redis
###############################################################################
helm upgrade ges-redis helm_repo/redis --install --version=16.12.2 -n ges -f /workspace/services/ges/overrides.yaml -f /workspace/services/ges/01_chart_redis/overrides.yaml