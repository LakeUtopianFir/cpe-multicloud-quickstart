variable "project" {
    type = string
    description = "Project Name"
}

variable "region" {
    type = string
    description = "GCP Region"
}

variable "repoid" {
    type = string
    description = "The last part of the repository name"
}

variable "imagerepoexists" {
    type = bool
    description = "Pre-run computed value if image artifactory already exists"
}

variable "chartrepoexists" {
    type = bool
    description = "Pre-run computed value if chart artifactory already exists"
}

variable "remoteregistry" {
    type = string
    description = "Address of remote registry"
}

variable "remotehelm" {
    type = string
    description = "Address of remote registry"
}

variable "remoteregistry_user" {
    type = string
    description = "Remote registry user"
}

variable "remoteregistry_pass" {
    type = string
    sensitive   = true
    description = "Remote registry user password"
}

# Those are images and charts hosted on jFrog edge
# For third-party images and charts you should make your own arrangememnts
# Once initially sed - comment them out only to pull latest version you may need.

variable "images" {
    type = map
    default = {
        "auth/gws-core-auth" = "100.0.009.3776"
        "auth/gws-core-environment" = "100.0.009.1954"
        "auth/gws-ui-auth" = "100.0.009.1359"
        "cce/recording-provider" = "100.0.1001610"
        "cxcontact/cxc-amark-app" = "100.0.030.0004.9415"
        "cxcontact/cxc-amark-ui" = "100.0.030.0004.8968"
        "cxcontact/cxc-campaign-manager" = "100.0.030.0004.4052"
        "cxcontact/cxc-compliance" = "100.0.030.0004.4147"
        "cxcontact/cxc-job-scheduler" = "100.0.030.0004.2948"
        "cxcontact/cxc-list-builder" = "100.0.030.0004.4996"
        "cxcontact/cxc-list-manager" = "100.0.030.0004.4083"
        "cxcontact/deploy_cx_contact" = "100.0.029.0005.453"
        "deploy_ucsx" = "100.0.097.0009"
        "designer/das" = "100.0.001.0043"
        "designer/designer" = "100.0.202.0011"
        "gcxi/gcxi" = "100.0.028.0000"
        "gcxi/gcxi_control" = "100.0.028.0000"
        "gcxi/raa" = "100.0.011.0100"
        "genesys/ges" = "100.0.002.2105"
        "genesys/katana/tenant_node" = "100.0.1000068"
        "genesys/katana/tenant_pgdb_init" = "100.0.1000068"
        "genesys/katana/tenant_pulse_init" = "100.0.1000068"
        "gim/gca" = "100.0.100.2300"
        "gim/gim" = "100.0.116.2900"
        "gim/gsp" = "100.0.100.1400"
        "gvp/gvp_configserver_configserverinit" = "100.0.100.0056"
        "gvp/gvp_configserver_servicehandler" = "100.0.100.0056"
        "gvp/gvp_confserv" = "100.0.100.0056"
        "gvp/gvp_rm" = "100.0.100.0152"
        "gvp/gvp_rm_cfghandler" = "100.0.100.0152"
        "gvp/gvp_rs" = "100.0.100.0133"
        "gvp/gvp_rs_init" = "100.0.100.0133"
        "gvp/gvp_sd" = "100.0.100.0055"
        "gvp/multicloud/gvp_mcp_confighandler" = "100.0.100.0070"
        "gvp/multicloud/gvp_mcp" = "100.0.100.0070"
        "gvp/multicloud/gvp_mcp_servicehandler" = "100.0.100.0070"
        "gvp/multicloud/gvp_snmp" = "100.0.100.0027"
        "gws/gws-app-provisioning" = "9.0.001.05"
        "gws/gws-app-workspace" = "9.0.001.00"
        "gws/gws-platform-chat" = "9.0.000.54"
        "gws/gws-platform-configuration" = "9.0.000.91"
        "gws/gws-platform-datacollector" = "9.0.000.60"
        "gws/gws-platform-ixn" = "9.0.000.53"
        "gws/gws-platform-ocs" = "9.0.000.56"
        "gws/gws-platform-setting" = "9.0.000.62"
        "gws/gws-platform-statistics" = "9.0.000.71"
        "gws/gws-platform-ucs" = "9.0.000.52"
        "gws/gws-platform-voice" = "9.0.000.76"
        "gws/gws-system-nginx" = "9.0.000.26"
        "gws/gws-ui-crmworkspace" = "9.0.000.72"
        "gws/gws-ui-provisioning" = "9.0.000.96"
        "gws/gws-ui-workspace" = "9.0.000.93"
        "iwddm/iwd_dm_cloud" = "100.0.003.1597"
        "ixn/interaction_server" = "100.0.006.1204"
        "ixn/ixn_node" = "100.0.007.0002"
        "ixn/ixn_vq_node" = "100.0.007.0002"
        "nexus/iwd" = "100.0.087.2006"
        "nexus/iwd-email" = "100.0.087.0488"
        "nexus/nexus" = "100.0.122.2868"
        "nexus/tenant_deployment" = "100.0.122.2868"
        "pulse/collector" = "100.0.000.0012"
        "pulse/configurator" = "100.0.000.0012"
        "pulse/cs_proxy" = "100.0.000.0012"
        "pulse/init" = "100.0.000.0012"
        "pulse/lds" = "100.0.000.0012"
        "pulse/monitor_dcu_push_agent" = "100.0.000.0012"
        "pulse/monitor_lds_push_agent" = "100.0.000.0012"
        "pulse/pulse" = "100.0.000.0012"
        "pulse/ss" = "100.0.000.0012"
        "pulse/userpermissions" = "100.0.000.0012"
        "tlm/telemetry-service" = "100.0.006.1685"
        "ucsx/ucsx" = "100.0.097.0009"
        "voice/agent_node" = "100.0.1000013"
        "voice/callthread_node" = "100.0.1000013"
        "voice/config_node" = "100.0.1000010"
        "voice/dialplan_node" = "100.0.1000015"
        "voice/ors_node" = "100.0.1000056"
        "voice/registrar_node" = "100.0.1000019"
        "voice/rq_node" = "100.0.1000010"
        "voice/sip_node" = "100.0.1000030"
        "voice/sipfe_node" = "100.0.1000009"
        "voice/sipproxy_node" = "100.0.1000019"
        "voice/voicemail_node" = "100.0.1000009"
        "webrtc/coturn" = "100.0.044.0000"
        "webrtc/webrtc" = "100.0.044.0000"
    }
}

variable "charts" {
    type = map
    default = {
        "cxcontact" = "029.0005.342"
        "designer" = "100.0.122+1407"
        "designer-das" = "100.0.111+0806"
        "designer" = "100.0.122+1407"
        "gauth" = "100.0.009+0153"
        "gca" = "100.0.100+2300"
        "gca-monitoring" = "100.0.100+2300"
        "gcxi" = "100.0.028+0000"
        "gcxi-raa" = "100.0.011+0100"
        "ges" = "100.0.002+0010"
        "gim" = "100.0.116+2900"
        "gsp" = "100.0.100+1400"
        "gvp-configserver" = "100.0.1000056"
        "gvp-mcp" = "100.0.1000070"
        "gvp-rm" = "100.0.1000152"
        "gvp-rs" = "100.0.1000133"
        "gvp-sd" = "100.0.1000055"
        "gws-ingress" = "1.0.28"
        "gws-services" = "1.0.92"
        "iwd" = "100.0.0872006"
        "iwddm-cronjob" = "100.0.006+0003"
        "iwdem" = "100.0.0870488"
        "ixn" = "100.0.003+20"
        "nexus" = "100.0.1222868"
        "pulse" = "100.0.000+0012"
        "dcu" = "100.0.000+0012"
        "init" = "100.0.000+0012"
        "init-tenant" = "100.0.000+0012"
        "lds" = "100.0.000+0012"
        "permissions" = "100.0.000+0012"
        "tenant" = "100.0.1000060"
        "telemetry-service" = "100.0.006+1685"
        "tenant-monitor" = "100.0.1000060"
        "ucsx" = "100.0.0970009"
        "ucsx-addtenant" = "100.0.0970009"
        "voice-agent" = "100.0.1000005"
        "voice-callthread" = "100.0.1000006"
        "voice-config" = "100.0.1000004"
        "voice-dialplan" = "100.0.1000007"
        "voice-ors" = "100.0.1000018"
        "voice-registrar" = "100.0.1000007"
        "voice-rq" = "100.0.1000004"
        "voice-sip" = "100.0.1000017"
        "voice-sipfe" = "100.0.1000006"
        "voice-sipproxy" = "100.0.1000004"
        #"voice-voicemail" = "100.0.1000012" # n/a on edge - using 100.0.1000011
        "voice-voicemail" = "100.0.1000011"
        "webrtc-service" = "100.0.041+0000"
        "wwe-nginx" = "9.0.5"
    }
}