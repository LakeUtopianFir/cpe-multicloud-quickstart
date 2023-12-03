# This is adding or updating origin/subdomain per Environment
#
# INPUT_COMMAND shoulbe like "cors 100 ixn-100 /USW1"
# three words separated by space:
#   #1 - cors - command
#   #2 - tenant ID
#   #3 - subdomain that we add to origins list - for new API only (not used now)
#   #4 - location (optional)
#
# Example: "cors 100"
# Note:    It ADDS new or UPDATES existing cors-origins for environment
#
## NEW API is: /environment/v3/cors - we avoid using it yet
## OLD API is: /environment/v3/contact-centers/$UUID/settings - using this one still
## Reasons is that:
##  - GES is provisioning using old API only
##  - if we start using new API, gauth will create DB table to store CORS origins there, and will NOT accept old API

## Clarification from Gauth team (Alexander Strouk)
## As regards /environment/v3/cors, you can use it in PE deployments, 
## but we have NOT officially migrated to the new CORS in cloud envs yet. 
## We plan to do it by the end of Q1 22. You must use it for all writes and deletes though, 
## if you decide to switch to it. Please, note that you have to switch to it right after Auth deployment. 
## Otherwise, you will need to migrate old data to the new interface at some point.

TID=$2
DMN=$3
LOCATION=$4
domain=$5

echo $TID
echo $DMN
echo $LOCATION
echo $domain

#TID=$(echo $INPUT_COMMAND | awk '{print $2}')
#DMN=$(echo $INPUT_COMMAND | awk '{print $3}')
#LOCATION=$(echo $INPUT_COMMAND | awk '{print $4}')

[[ -z "$TID" ]] && TID="100"
[[ -z "$LOCATION" ]] && LOCATION="/"

gauth_admin_username=$( kubectl get secrets deployment-secrets -n gauth -o custom-columns=:data.gauth_admin_username --no-headers | base64 -d )
gauth_admin_password_plain=Genesys1234

CREDS="$gauth_admin_username:$gauth_admin_password_plain"
domain=cluster02.gcp.demo.genesys.com

echo $CREDS
echo $domain

case "$TID" in
    100) UUID=9350e2fc-a1dd-4c65-8d40-1f75a2e080dd
          ;;
    104) UUID=8839df61-f6dc-4b0b-b443-1d10827a24c1
          ;;
    105) UUID=4ebe25ba-a6c6-47ca-a670-10632fc38a0b
          ;;
    200) UUID=9e641650-f063-11eb-9a03-0242ac130003
          ;;
    *)   echo "ERROR: did not recognize tenant ID (new?)"
         exit 1
          ;;
esac

# We will Curl from gauth pod, because no access from GH runner to ingress https://gauth.$domain
GAPOD=$(kubectl get po -n gauth | grep gauth-auth | grep Running | grep -v gauth-auth-ui -m1 | awk '{print $1}')


echo "*** Pre-change list of origins:"
#curl -skL https://gauth.$domain/environment/v3/cors -u $CREDS | jq .data.origins
# NEW API
#kubectl exec $GAPOD -- bash -c "curl -s http://gauth-environment/environment/v3/cors -u $CREDS" | jq .data.origins
# OLD API
kubectl exec $GAPOD --namespace="gauth" -- bash -c "curl -s https://gauth-int.$domain/environment/v3/contact-centers/$UUID/settings -u $CREDS" | jq .data.settings

# Older API - add all origins in one request
# ucsx? tlm?
CORS="https://gauth.$domain, \
https://gws.$domain, \
https://wwe.$domain, \
https://prov.$domain, \
https://webrtc.$domain, \
http://cxc.$domain, \
https://cxc.$domain, \
https://designer.$domain, \
https://iwd.$domain, \
https://digital.$domain, \
https://pulse.$domain, \
https://web-gcxi.$domain, \
https://web-gcxi-100.$domain, \
https://ges.$domain"
# curl -kL -XPOST -u $CREDS "https://gauth.$domain/environment/v3/contact-centers/$UUID/settings"  \
#	-H 'Content-Type: application/json' --data-raw "
#	{\"data\":{
#	  \"location\": \"/\",
#	  \"name\": \"cors-origins\",
#	  \"shared\": \"true\",
#	  \"value\": \"$CORS\"
#    }}"


ORIGINS()
{
  cat <<EOF
  { "data": {
          "location": "$LOCATION",
          "name": "cors-origins",
          "shared": "true",
          "value": "$CORS"
        }
  }
EOF
}

kubectl exec $GAPOD --namespace="gauth" -- bash -c "curl -s -XPOST https://gauth-int.$domain/environment/v3/contact-centers/$UUID/settings -u $CREDS -H 'Content-Type: application/json' -d '$(ORIGINS)'" | tee RSP


##################################
# New API - add single origin only

#curl -skL -XPOST "https://gauth.$domain/environment/v3/cors" -u $CREDS \
#  -H 'Content-Type: application/json' -d"
#  {\"data\": {
#      \"contactCenterId\":\"$UUID\",
#      \"origin\":\"https://$DMN.$domain\"
#  }}" | tee RSP

#NEW_ORIGIN()
#{
#  cat <<EOF
#  { "data":
#        {  "contactCenterId":"$UUID",
#           "origin":"https://$DMN.$domain"
#        }
#  }
#EOF
#}
#
#kubectl exec $GAPOD -- bash -c "curl -s -XPOST http://gauth-environment/environment/v3/cors -u $CREDS -H 'Content-Type: application/json' -d '$(NEW_ORIGIN)'" | tee RSP
sleep 5
[[ "$(cat RSP | jq .status.code)" != "0" ]] && echo "ERROR: failed http request to Gauth" && exit 1



echo "*** Current list of origins:"
#curl -skL https://gauth.$domain/environment/v3/cors -u $CREDS | jq .data.origins
# NEW API
#kubectl exec $GAPOD -- bash -c "curl -s http://gauth-environment/environment/v3/cors -u $CREDS" | jq .data.origins
# OLD API
kubectl exec $GAPOD --namespace="gauth" -- bash -c "curl -s https://gauth-int.$domain/environment/v3/contact-centers/$UUID/settings -u $CREDS" | jq .data.settings