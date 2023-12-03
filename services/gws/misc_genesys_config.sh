# This is to create/update Genesys basic configuration

# INPUT_COMMAND shoulbe like "misc_genesys_config <domain> <all/create/update>"
#   #1 - all, create, update. 'create' creates user accounts, 'update' updates configuration, 'all' does both create and update
#   #2 - domain ex cluster03.gcp.demo.genesys.com

set -x

ACT=$1
domain=$2

echo action=$ACT
echo domain=$domain

[[ "$ACT" != "all" && "$ACT" != "create" && "$ACT" != "update" ]] && echo "ERROR: action must be either [all|create|update]'" && exit 1

gauth_client_id=gauth-client
gauth_client_secret=secret

gauth_user_name=t100\\default
gauth_user_pass=password
userPassword="Genesys1234"

###++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
GET_TOKEN()
{
    curl -k --location --request POST https://gauth.$domain/auth/v3/oauth/token --user $gauth_client_id:$gauth_client_secret --header 'Content-Type: application/x-www-form-urlencoded' --data-urlencode username=$gauth_user_name --data-urlencode 'grant_type=password' --data-urlencode password=$gauth_user_pass | tee RSP

    [[ $(cat RSP | jq .token_type) != "\"bearer\"" ]] && echo "ERROR: Could not get token from Gauth. Got: "$(cat RSP) && exit 1
    gauth_token=$(cat RSP | jq -r '.access_token')
    echo "\n"

}

INIT_PROVISIONING() {
    x=1
    while [ $x -le 60 ]
    do
        curl -k --location --request POST https://gws.$domain/provisioning/v3/initialize-provisioning --header "Authorization: Bearer $gauth_token" | tee RSP
        if [[ $(cat RSP | jq -r '.status.code') != "0" ]]; then
            echo "Provisioning not ready yet...sleeping for 10 seconds...got: "$(cat RSP)
            sleep 10
        else
            echo "Provisioning ready...got: "$(cat RSP)
            sleep 10
            return
        fi
        [[ $(cat RSP | jq -r '.status.code') != "0" ]] && echo "ERROR: Could not Initialise Provisioning. Got: "$(cat RSP) && 
        x=$(( $x + 1 ))
    done

    exit
}

AGT_GRP_UPDATE()
{
  cat <<EOF
    {
        "data": {
            "deltaGroupInfo": {
                "deltaGroup": {
                    "DBID": $genconfig_agt_grp_dbid,
                    "managerDBIDs": ["$genconfig_supervisor_dbid"],
                    "\$class": "CfgGroup"
                },
                "\$class": "CfgDeltaGroup",
                "deletedManagerDBIDs": []
            },
            "\$class": "CfgDeltaAgentGroup"
        }
    }
EOF
}

LOAD_TEMPLATE()
{
    eval "cat <<EOF
    $(<$1)
    EOF
    " 2> /dev/null
}

CREATE_OBJECT() {
    #Signature: CREATE_OBJECT "object-type" "alternate-result-code" "url" "body"
    curl -k --location --request POST https://gws.$domain/provisioning/v3/$3 --header "Authorization: Bearer $gauth_token" -H 'Content-Type: application/json' -d "$(LOAD_TEMPLATE $4)" | tee RSP
    [[ $(cat RSP | jq -r '.status.code') != "0" && $(cat RSP | jq -r '.status.code') != "$2" ]] && echo "ERROR: Could not Create Object of type [$1]. Got: "$(cat RSP) && exit 1
}

GET_OBJECT() {
    #Signature: GET_OBJECT "object-type" "url"
    curl -k --location --request GET https://gws.$domain/provisioning/v3/$2 --header "Authorization: Bearer $gauth_token" | tee RSP
    [[ $(cat RSP | jq -r '.status.code') != "0" ]] && echo "ERROR: Could not GET Object of type [$1]. Got: "$(cat RSP) && exit 1
}

UPDATE_OBJECT() {
    #Signature: CREUPDATE_OBJECTATE_OBJECT "object-type" "alternate-result-code" "url" "body"
    curl -k --location --request PUT https://gws.$domain/provisioning/v3/$3 --header "Authorization: Bearer $gauth_token" -H 'Content-Type: application/json' -d "$4" | tee RSP
    [[ $(cat RSP | jq -r '.status.code') != "0" && $(cat RSP | jq -r '.status.code') != "$2" ]] && echo "ERROR: Could not PUT Object of type [$1]. Got: "$(cat RSP) && exit 1
}

###+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

class="\$class"
if [ "$ACT" == "create" ] || [ "$ACT" == "all" ]; then
    
    GET_TOKEN
    INIT_PROVISIONING
    #echo Got this gauth token: $gauth_token

    jq -c '.[]' objects-lists/objects-to-create.json | while read obj_to_create; do
        obj_name=$(echo $obj_to_create | jq -r '.name')
        obj_post_url=$(echo $obj_to_create | jq -r '.post_url')
        obj_template_file="templates/$(echo $obj_to_create | jq -r '.template_file')"
        obj_list_file=objects-lists/$(echo $obj_to_create | jq -r '.list_file')

        jq -c '.[]' $obj_list_file | while read admin; do
            attr_counter=1
            nb_attr=$(echo $admin | jq -r 'keys' | jq 'length')
            echo nb_attr=$nb_attr
            echo $admin | jq -r 'keys | .[]' | while read key; do
                let attr_counter=attr_counter+1 
                value=$(echo $admin | jq -r .$key)
                
                #mycmd="$key=\"$value\""
                #eval $mycmd
                
                key_var=$key
                value_var=$value
                printf -v "$key_var" "%s" "$value_var"
                #echo user=$userName fn=$firstName ln=$lastName ag=$accessGroups
                if [ $attr_counter -gt $nb_attr ]; then
                    CREATE_OBJECT $obj_name 609 $obj_post_url $obj_template_file
                fi
            done
        done
    done
fi

if [ "$ACT" == "update" ] || [ "$ACT" == "all" ]; then
    GET_TOKEN
    INIT_PROVISIONING
    #echo Got this gauth token: $gauth_token

    # Set supervisor of 'Main-Agent-Group'
    GET_OBJECT "agent-groups" "configuration/objects/agent-groups?name=Main-Agent-Group"
    genconfig_agt_grp_dbid=$(cat RSP | jq -r '.data.objects[0].groupInfo.DBID')
    GET_OBJECT "agent-groups" "configuration/objects/persons?user_name=sup1@pec.com"
    genconfig_supervisor_dbid=$(cat RSP | jq -r '.data.objects[0].DBID')    
    UPDATE_OBJECT "agent-groups" 609 "configuration/objects/agent-groups/$genconfig_agt_grp_dbid" "$(AGT_GRP_UPDATE)"

    # Configure Designer ReportingURL to match deployed elasticsearch
    GET_OBJECT "transactions" "configuration/objects/transactions?name=DesignerEnv"
    genconfig_designer_txn_dbid=$(cat RSP | jq -r '.data.objects[0].DBID')
    # Remove existing option     
    UPDATE_OBJECT "transactions" 650 "configuration/objects/transactions/$genconfig_designer_txn_dbid" "{\"data\":{\"deletedUserProperties\":[{\"key\":\"reporting\",\"type\":\"kvlist\",\"value\":[]}],\"deltaTransaction\":{\"DBID\":$genconfig_designer_txn_dbid,\"\$class\":\"CfgTransaction\"},\"\$class\":\"CfgDeltaTransaction\"}}"
    # Create option
    UPDATE_OBJECT "transactions" 0 "configuration/objects/transactions/$genconfig_designer_txn_dbid" "{\"data\":{\"deltaTransaction\":{\"DBID\":$genconfig_designer_txn_dbid,\"userProperties\":[{\"key\":\"reporting\",\"type\":\"kvlist\",\"value\":[{\"key\":\"ReportingURL\",\"type\":\"str\",\"value\":\"http://elastic-es-http.infra:9200\"}]}],\"\$class\":\"CfgTransaction\"},\"\$class\":\"CfgDeltaTransaction\"}}"

    # Create New Capacity Rule
    GET_OBJECT "capacity-rules" "capacity-rules?name=CR-All-One-Each"
    genconfig_default_cr_dbid=$(cat RSP | jq -r '.data.capacityRule.DBID')

    # Make this CR the tenant's default Capacity Rule
    GET_OBJECT "tenants" "/configuration/objects/tenants?dbid:int=1"
    tenant_default_cr_dbid=$(cat RSP | jq -r '.data.objects[0].defaultCapacityRuleDBID')

    if [ "$tenant_default_cr_dbid" != "$genconfig_default_cr_dbid" ]; then
        UPDATE_OBJECT "tenants" 609 "configuration/objects/tenants/1" "{\"data\":{\"deltaTenant\":{\"DBID\":1,\"defaultCapacityRuleDBID\":$genconfig_default_cr_dbid,\"\$class\":\"CfgTenant\"},\"\$class\":\"CfgDeltaTenant\"}}"
    fi

    # Update WWE options
    jq -c '.data.newOptions["interaction-workspace"]' templates/global-options-update.json | jq -r 'keys | .[]' | while read key; do
        UPDATE_OBJECT "global-options" 650 "options" $"{\"data\":{\"deletedOptions\":{\"interaction-workspace\":{\"$key\":\"\"}}}}"
    done

    UPDATE_OBJECT "global-options" 609 "options" "$(LOAD_TEMPLATE templates/global-options-update.json)"
fi