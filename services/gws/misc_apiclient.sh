# This is to show|add|update|delete API client

# INPUT_COMMAND shoulbe like "apiclient [show|add|update|delete] <client_id> <domain>"
# three words separated by space:
#   #1 - apiclient - command
#   #2 - show, add, update (redirectURIs list), delete
#   #3 - client_id (ex: gcxi_client) or "all" keyword 
#   #4 - domain ex cluster03.gcp.demo.genesys.com

#set -x

# API clients list for bulk operation ("all")
CLIENTS=(\
external_api_client \
gws-app-provisioning \
gws-app-workspace \
cx_contact \
designer_client \
gcxi_client \
ges_client \
nexus_client \
iwd_client \
pulse_client \
ucsx_api_client \
webrtc-clientid \
bds-clientid)

ACT=$2
CLN=$3
domain=$4

#ACT=$(echo $INPUT_COMMAND | awk '{print $2}')
#CLN=$(echo $INPUT_COMMAND | awk '{print $3}')
#domain=$(echo $INPUT_COMMAND | awk '{print $4}')

echo $ACT
echo $CLN
echo $domain

# Redirect URIs allowed for these clients (redirections during SSO auth)
REDIRECT_URIS=$(cat << EOF
"https://gauth.$domain",
"https://gws.$domain",
"https://wwe.$domain",
"https://prov.$domain",
"https://webrtc.$domain",
"https://cxc.$domain",
"http://cxc.$domain",
"https://designer.$domain",
"https://iwd.$domain",
"https://digital.$domain",
"https://pulse.$domain",
"https://web-gcxi.$domain",
"https://web-gcxi-100.$domain",
"https://ges.$domain",
"https://webphone.$domain"
EOF
)


#gauth_admin_username=$( kubectl get secrets deployment-secrets -n gauth -o custom-columns=:data.gauth_admin_username --no-headers | base64 -d )
#gauth_admin_password_plain=$gauth_admin_username

echo $gauth_admin_username
echo $gauth_admin_password_plain

###++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
CREDS="'$gauth_admin_username:$gauth_admin_password_plain'"
[[ "$ACT" != "show" && "$ACT" != "add" && "$ACT" != "update" && "$ACT" != "delete" ]] && echo "ERROR: command must be like 'apiclient [add|update|delete] <client_id>'" && exit 1
[[ "$CLN" == "" ]] && echo "ERROR: need client ID" && exit 1
[[ "$CLN" != "all" ]] && CLIENTS=($CLN)

# We will Curl from gauth pod, because no access from GH runner to ingress https://gauth.$domain
GAPOD=$(kubectl get po -n gauth | grep gauth-auth | grep Running | grep -v gauth-auth-ui -m1 | awk '{print $1}')

echo "*** Pre-change list of clients:"
#curl -skL https://gauth.$domain/auth/v3/ops/clients -u "$gauth_admin_username:$gauth_admin_password_plain" | jq .data[].client_id
kubectl exec $GAPOD --namespace="gauth" -- bash -c "curl -s https://gauth-int.cluster02.gcp.demo.genesys.com/auth/v3/ops/clients -u $CREDS" | jq .data[].client_id || true


###++++++++ Show all settings except secrets and keys, for certain api client ++
if [ "$ACT" == "show" ]; then
    if [ "$CLN" == "all" ]; then
        echo "*** Pre-change, all existing clients:"
        kubectl exec $GAPOD --namespace="gauth" -- bash -c "curl -s https://gauth-int.cluster02.gcp.demo.genesys.com/auth/v3/ops/clients -u $CREDS" | tee RSP
        [[ "$(cat RSP | jq .status.code)" != "0" ]] && echo "ERROR: Clients list not found? Failed http request to Gauth: "$(cat RSP | jq .status) && exit 1
        cat RSP | jq .data[]
    else
        echo "*** Pre-change client $CLN properties:"
        kubectl exec $GAPOD --namespace="gauth" -- bash -c "curl -s https://gauth-int.cluster02.gcp.demo.genesys.com/auth/v3/ops/clients/$CLN -u $CREDS" | tee RSP
        [[ "$(cat RSP | jq .status.code)" != "0" ]] && echo "ERROR: Client not found? Failed http request to Gauth: "$(cat RSP | jq .status) && exit 1
        cat RSP | jq .data[]
    fi
    exit 0
fi


###+++++++++++++ Add new api client (will return error if already exists) ++++++
if [ "$ACT" == "add" ]; then

    #################################################################
    ###                 ADJUST LIST OF redirectURIs              ####
    #################################################################

NEW_API_CLIENT()
{
  cat <<EOF
  { "data":
        {  "redirectURIs": [
              $REDIRECT_URIS
           ],
           "client_id":"$1",
           "name":"$1",
           "description":"$1",
           "client_secret": "secret",

           "refreshTokenExpirationTimeout":2592000,
           "clientType":"CONFIDENTIAL",
           "internalClient":true,
           "authorizedGrantTypes":[
              "refresh_token", "implicit", "client_credentials", "password", "authorization_code",
              "urn:ietf:params:oauth:grant-type:token-exchange", "urn:ietf:params:oauth:grant-type:jwt-bearer"
           ],
           "authorities":["ROLE_INTERNAL_CLIENT"],
           "accessTokenExpirationTimeout":43200,
           "scope":["*"]
        }
  }
EOF
}

    # can also bind client to environment, adding like:
    #   "contactCenterIds": [
    #     "9350e2fc-a1dd-4c65-8d40-1f75a2e080dd"
    #   ],

    for cl in ${CLIENTS[*]};do
        #curl -skL -XPOST https://gauth.$domain/auth/v3/ops/clients -u $gauth_admin_username:$gauth_admin_password_plain \
        #-H 'Content-Type: application/json' -d "$(NEW_API_CLIENT)" | tee RSP
        echo "____________________Adding apiclient: $cl __________________________________"
        kubectl exec $GAPOD --namespace="gauth" -- bash -c "curl -s -XPOST https://gauth-int.cluster02.gcp.demo.genesys.com/auth/v3/ops/clients -u $CREDS -H 'Content-Type: application/json' -d '$(NEW_API_CLIENT $cl)'" | tee RSP
        sleep 5
        echo;echo "________________________________________________________________________________"
    done
fi


###++++++++++++++++++++++++++++++ Delete api client ++++++++++++++++++++++++++++
if [ "$ACT" == "delete" ]; then
    for cl in ${CLIENTS[*]};do
        echo "____________________Deleting apiclient: $cl __________________________________"
        #curl -skL -XDELETE https://gauth.$domain/auth/v3/ops/clients/$CLN \
        #  -u "$gauth_admin_username:$gauth_admin_password_plain" | tee RSP
        kubectl exec $GAPOD --namespace="gauth" -- bash -c "curl -s -XDELETE https://gauth-int.cluster02.gcp.demo.genesys.com/auth/v3/ops/clients/$cl -u $CREDS" | tee RSP
        echo;echo "________________________________________________________________________________"
    done
fi


###++++++++++++++++++++++ Update list of redirect URIs only ++++++++++++++++++++
if [ "$ACT" == "update" ]; then

     #################################################################
     ###                 ADJUST LIST OF redirectURIs              ####
     #################################################################

NEW_REDURI()
{
  cat <<EOF
  { "data":
       {"redirectURIs": [
            $REDIRECT_URIS
        ]
      }
  }
EOF
}

    for cl in ${CLIENTS[*]};do
        echo "____________________Updating apiclient: $cl __________________________________"
        #curl -skL -XPUT https://gauth.$domain/auth/v3/ops/clients/$CLN -u "$gauth_admin_username:$gauth_admin_password_plain" \
        #  -H 'Content-Type: application/json' -d "$(NEW_REDURI)" | tee RSP
        kubectl exec $GAPOD --namespace="gauth" -- bash -c "curl -s -XPUT https://gauth-int.cluster02.gcp.demo.genesys.com/auth/v3/ops/clients/$cl -u $CREDS -H 'Content-Type: application/json' -d '$(NEW_REDURI)'" | tee RSP
        echo;echo "________________________________________________________________________________"
    done
fi

###+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


[[ "$(cat RSP | jq .status.code)" != "0" && "$CLN" != "all" ]] && echo "ERROR: failed http request to Gauth: "$(cat RSP | jq .status) && exit 1


echo "*** Post-change, current list of cients:"
kubectl exec $GAPOD --namespace="gauth" -- bash -c "curl -s https://gauth-int.cluster02.gcp.demo.genesys.com/auth/v3/ops/clients -u $CREDS" | jq .data[].client_id