set -x

echo "***********************"
echo Running post-release-script.sh for DOMAIN=$DOMAIN
echo "***********************"

sleep 60

pwd
pushd ../..
pwd
ls -lr

chmod +x ./misc_genesys_config.sh
./misc_genesys_config.sh all $DOMAIN

popd
