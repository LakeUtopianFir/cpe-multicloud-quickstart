# This is to create new GWS environment + CCID

# INPUT_COMMAND shoul be like "ccid 100 /USW1"
# three words separated by space:
#   #1 - ccid - command
#   #2 - tenant ID
#   #3 - location (optional)


TID=$2
LOCATION=$3
domain=$4

echo $TID
echo $LOCATION
echo $domain

#TID=$(echo $INPUT_COMMAND | awk '{print $2}')
[[ -z "$TID" ]] && TID="100"
#LOCATION=$(echo $INPUT_COMMAND | awk '{print $3}')
[[ -z "$LOCATION" ]] && LOCATION="/USW1"

gauth_admin_username=$( kubectl get secrets deployment-secrets -n gauth -o custom-columns=:data.gauth_admin_username --no-headers | base64 -d )
gauth_admin_password_plain=Genesys1234
CREDS="$gauth_admin_username:$gauth_admin_password_plain"

echo $CREDS

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


###+++++++++++++ Create new environment (will return error if already exists) ++++++

## tenant-9350e2fc-a1dd-4c65-8d40-1f75a2e080dd-cfgmaster.service.dc1.consul
## tenant-9350e2fc-a1dd-4c65-8d40-1f75a2e080dd.voice.svc.cluster.local
## tenant-9350e2fc-a1dd-4c65-8d40-1f75a2e080dd.${VOICE_NAMESPACE}.svc.${DNS_SCOPE}

NEW_DATA()
{
  cat <<EOF
  { "data": {
        "username": "default",
        "password": "password",
        "id": "$UUID",
        "connectionProtocol": "addp",
        "localTimeout": 60,
        "remoteTimeout": 90,
        "tenant": "Environment",
        "appName": "Cloud",
        "traceMode": "CFGTMBoth",
        "tlsEnabled": false,
        "configServers": [{
            "primaryPort": 8888,
            "readOnly": false,
            "primaryAddress": "tenant-$UUID-cfgmaster.service.dc1.consul",
            "locations": "$LOCATION"
        }]
    }
  }
EOF
}

echo $UUID
echo $NEW_DATA

kubectl exec $GAPOD --namespace="gauth" -- bash -c "curl -s -XPOST https://gauth-int.$domain/environment/v3/environments -u $CREDS -H 'Content-Type: application/json' -d '$(NEW_DATA)'" | tee RSP
sleep 3

###++++++++++++++
[[ "$(cat RSP | jq .status.code)" != "0" ]] && echo "ERROR 1: failed http request to Gauth: "$(cat RSP | jq .status) && exit 1

NEW_ENV=$(cat RSP | jq .path | cut -d'/' -f3| sed 's/"//')

echo "*** Current list of environments:"
kubectl exec $GAPOD --namespace="gauth" -- bash -c "curl -s https://gauth-int.$domain/environment/v3/environments -u $CREDS" | jq .data[]


###### Create CCID ######

NEW_DATA()
{
  cat <<EOF
    {
        "data": {
            "domains": ["t${TID}"],
            "environmentId": "$NEW_ENV",
            "auth": "configServer",
            "id" : "$UUID"
        }
    }
EOF
}

kubectl exec $GAPOD --namespace="gauth" -- bash -c "curl -s -XPOST https://gauth-int.$domain/environment/v3/contact-centers -u $CREDS -H 'Content-Type: application/json' -d '$(NEW_DATA)'" | tee RSP
sleep 3

###++++++++++++++
[[ "$(cat RSP | jq .status.code)" != "0" ]] && echo "ERROR 2: failed http request to Gauth: "$(cat RSP | jq .status) && exit 1

echo "*** Current list of CCIDs:"
kubectl exec $GAPOD --namespace="gauth" -- bash -c "curl -s https://gauth-int.$domain/environment/v3/contact-centers -u $CREDS" | jq .data[]