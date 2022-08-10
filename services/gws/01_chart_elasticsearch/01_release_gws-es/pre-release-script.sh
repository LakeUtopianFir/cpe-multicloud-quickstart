###############################################################################
# Because of using helm-repo as private repository  in gh-workflow,
# we have to reddefine it for installing from public ones 
###############################################################################
helm repo add --force-update helm-repo https://charts.bitnami.com/bitnami
helm repo update
helm search repo helm_repo/elasticsearch --version=17.9.29

