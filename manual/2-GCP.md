# Summary
The steps outline below will provision the GCP project with the necessary network services as well as stand up a Google Kubernetes Enginer (GKE) cluster. 

The following Network Services are stood up within the GCP Project:
- VPC Network
- Subnets for the newly created VPC Network
- Google Cloud DNS
- Google Cloud Router
- Google Cloud NAT Gateway

When the GKE cluster is provisioned, the following is setup/created:
- 6 Nodes (each node is a e2-standard-16 VM)
- Storage Class for Filestore

## Provision 2-GCP
CloudBuild Trigger Name: 1-Provision-GCP-Platform

A CloudBuild trigger is created called "1-Provision-GCP-Platform" within the Google Cloud Project from the "1-prereqs" steps. Execute this trigger to start the provisioning of the GCP and GKE components. The CloudBuild trigger will execute Terraform to provision the various components outlined above. 

## Delegate DNS
If Cloud DNS is going to be used for DNS services then a delegation will need to be setup between the provider of the domain name being used and Cloud DNS. Cloud DNS will provide 4 nameservers in the zone that is created. Retreive these 4 nameservers DNS names and setup a NS record with the provider of the domain name to delegate the domain to the 4 Cloud DNS nameservers. 