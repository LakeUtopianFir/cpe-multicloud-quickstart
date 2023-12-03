###############################################################################
# Because of using helm-repo as private repository  in gh-workflow,
# we have to reddefine it for installing from public ones 
###############################################################################
helm repo add --force-update helm_repo https://simcubeltd.github.io/simcube-helm-charts/
helm repo update