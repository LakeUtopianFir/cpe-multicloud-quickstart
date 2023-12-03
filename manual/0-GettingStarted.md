# Summary

At the end of completing the procedures outlined in this repository, a fully functional Google Cloud environment will be provisioned with a running and ready to use MultiCloud Private Edition stack. 

# Technologies Used
The following frameworks, services, etc are used throughout the Quickstart deployment scripts:
- Terraform
- Helm
- Shell

# DNS Considerations and Delegation
The Terraform logic in the following procedures will setup Google Cloud DNS and create a wildcard A record entry with value of "*.PROVIDED_FQDN" for the MultiCloud applications. As the MultiCloud Services are spun up and if they require external access, then the wildcard entry will be used to provide DNS resolution. 

The expectation is that a domain name is already procured. This can be a newly purchased domain or an root/subdomain off an existing purchased domain...the decision is up to you. The Quickstart scripts will not purchase/procure the domain. 

Cloud DNS within Google Cloud is used natively within the Terraform and Helm logic throughout the provisioning process. Cloud DNS is not a mandatory service though and different DNS providers can be used if desired. If a different DNS provider is used, then the necessary A records will need to be setup. This can be a single wildcard entry (EX: *.fqdn.com where fqdn.com is substituted for your domain) to cover the spectrum of applications that are stood up or a unique A record for each MultiCloud Private Edition web application. If a unique entry for each web application is chosen, then the following URL's and A records needed are as follows:
- gauth.domain.com

# Repository Structure
To understand how this repository is structured, the following guidelines and schemea is used:

This repository is broken up into two sections:
* Platform - Terraform files to provision a new GCP project with the necessary Google API's and services. 
* Services - Helm Charts to provision the MultiCloud Private Edition containers. 

<pre>
multicloud-quickstart
|
├── platform - Terraform scripts that provision GCP with the necessary services, API enablement, etc
│   ├── terraform
|   |   ├── 1-prereqs   -   Terraform files that need to be manually invoked before Cloud Build Ci/CD can take over.
│   │   |   ├── 1-gcp - Sets up the GCP project with the necessary API's and creates a storage bucket for future Terraform state files
|   |   |   |   ├── main.tf
│   │   |   ├── 2-cloudbuild - Sets up the Cloud Build trigger jobs that will be invoked to provision the rest of GCP via Terraform and Private Edition with Helm
|   |   |   |   ├── main.tf
│   │   |   ├── 3-pe-secrets - Sets up the the Google Secrets with chosen passwords for the various MultiCloud services and accounts
|   |   |   |   ├── main.tf
|   |   ├── 2-gcp    -   Terraform files that will provision GCP services such as VPC, GKE, etc. All of these subfolders are executing by a CloudBuild trigger job
│   │   |   ├── 1-network - Provisions the GCP networking components needed such as VPC, DNS, Routers, NATS, etc
|   |   |   |   ├── main.tf
│   │   |   ├── 2-gke-cluster - Provisions the GKE cluster that MultiCloud will use
|   |   |   |   ├── main.tf
│   │   |   ├── 3-k8s-setup - Provisions the Filestore StorageClass for K8's on the newly provisioned GKE cluster
|   |   |   |   ├── main.tf
|   |   ├── 3-gcp-posttasks    -   Terraform files that perform post tasks such as configuring consul, MSSQL, etc
│   │   |   ├── 1-certs - Sets up the Ngnix Ingress for outside connections and Cert Manager
|   |   |   |   ├── main.tf
│   │   |   ├── 2-thirdparty - Sets up thirdparty components such as Consul, Kafka, MSSQL, etc
|   |   |   |   ├── main.tf
│   │   |   ├── 3-consul-mssql - Configures the thirdparty components such as a MSSQL database and related account. 
│   |   |   |   ├── main.tf
│   |   |   |   ├── variables.tf
|   |   ├── 4-artifactory-optional  -   Terraform job that will copy the MultiCloud Helm Charts and Containers out of the Genesys JFROG Artifactory into Google Artifacts.
                                        If you already have an established repo to store Helm Charts and Containers, then this job is not needed and you will need to perform your own copy job
│   |   |   ├── main.tf
│   |   |   ├── provision-gcp-repo.sh
│   ├── tfm - The Terraform submodules containing the resource and variable definitions
|   |   ├── 1-prereqs 
│   │   |   ├── 1-gcp - Sets up the GCP project with the necessary API's and creates a storage bucket for future Terraform state files
│   |   |   |   ├── main.tf
│   |   |   |   ├── variables.tf
│   |   |   |   └── README.md  -  Details on all inputs that must be modified
│   │   |   ├── 2-cloudbuild - Sets up the Cloud Build trigger jobs that will be invoked to provision the rest of GCP via Terraform and Private Edition with Helm
│   |   |   |   ├── main.tf
│   |   |   |   ├── variables.tf
│   |   |   |   └── README.md  -  Details on all inputs that must be modified
│   │   |   ├── 3-pe-secrets - Sets up the the Google Secrets with chosen passwords for the various MultiCloud services and accounts
│   |   |   |   ├── main.tf
│   |   |   |   ├── variables.tf
│   |   |   |   └── README.md  -  Details on all inputs that must be modified
|   |   ├── 2-gcp    -   Terraform files that will provision GCP services such as VPC, GKE, etc. All of these subfolders are executing by a CloudBuild trigger job
│   │   |   ├── 1-network - Provisions the GCP networking components needed such as VPC, DNS, Routers, NATS, etc
│   |   |   |   ├── main.tf
│   |   |   |   ├── variables.tf
│   |   |   |   └── README.md  -  Details on all inputs that must be modified
│   │   |   ├── 2-gke-cluster - Provisions the GKE cluster that MultiCloud will use
│   |   |   |   ├── main.tf
│   |   |   |   ├── variables.tf
│   |   |   |   └── README.md  -  Details on all inputs that must be modified
│   │   |   ├── 3-k8s-setup - Provisions the Filestore StorageClass for K8's on the newly provisioned GKE cluster
│   |   |   |   ├── main.tf
│   |   |   |   ├── variables.tf
│   |   |   |   └── README.md  -  Details on all inputs that must be modified
|   |   ├── 3-gcp-posttasks    -   Terraform files that perform post tasks such as configuring consul, MSSQL, etc
│   │   |   ├── 1-certs - Sets up the Ngnix Ingress for outside connections and Cert Manager
│   |   |   |   ├── main.tf
│   |   |   |   ├── variables.tf
│   |   |   |   └── README.md  -  Details on all inputs that must be modified
│   │   |   ├── 2-thirdparty - Sets up thirdparty components such as Consul, Kafka, etc
│   |   |   |   ├── main.tf
│   |   |   |   ├── variables.tf
│   |   |   |   └── README.md  -  Details on all inputs that must be modified
│   │   |   ├── 3-consul-mssql 
│   |   |   |   ├── main.tf
│   |   |   |   ├── variables.tf
|   |   ├── 4-artifactory-optional
│   |   |   ├── main.tf
│   |   |   ├── variables.tf
├── services - Helm charts that provisions the MultiCloud Private Edition stack
│   ├── [multicloud_service_helm_chart]  -  like "gauth", "iwd", ...
│   |   ├── XX_chart_product-subsystem
|   |   |   ├── XX_release_product
|   |   |   |   |── override_values.yaml
|   |   |   |   |── pre-release-script.yaml
|   |   |   |   |── post-release-script.yaml
|   |   |   |── chart.ver
|   |   |   |── override_values.yaml
|   └── provision-[product].sh - Shell script responsible for executing the Helm Charts for the specific product
└── cloudbuild-services-[product].yaml - Cloud Build YAML definition file.
</pre>
