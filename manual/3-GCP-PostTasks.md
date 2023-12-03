# Summary
The steps outline below will stand up third party services that the MultiCloud Private Edition stack relies on. 

The following services and applications are spun up on the newly created GKE cluster:
- Cert Manager
- Consul
- Kafka
- MSSQL
- Prometheus

After the following services are spun up, some extra configuration steps are then executed:
- Setting up MSSQL Database and User Accounts (Used in GVP)
- Configuring Consul Intentions
- Setting Stub DNS Zone in Kube-DNS config-map

## Provision 2-GCP-POSTTASKS
CloudBuild Trigger Name: 2-Post-Platform-Setup

A CloudBuild trigger is created called "2-Post-Platform-Setup" within the Google Cloud Project from the "1-prereqs" steps. Execute this trigger to start the provisioning of the GCP and GKE components. The CloudBuild trigger will execute Terraform to provision the various components outlined above. 