# Summary
The steps outline below will copy the Helm Charts and Container Images out of the Genesys provided JFrog Artifactory repository into your GCP Project and Google Artifacts service. This step is optional if you have a different repository you would like to story the Helm Charts and Container Images in. If you do decide to use your own repository, you may skip this step, but it would be up to you to define the procedure on copying the Helm Charts and Container Images out of JFrog and into your repository. 

**Please contact your Genesys Representative to obtain credentials into JFrog Artifactory.**

## Provision 4-Artifactory
CloudBuild Trigger Name: 0-Copy-Private-Edition-Containers

A CloudBuild trigger is created called "0-Copy-Private-Edition-Containers" within the Google Cloud Project from the "1-prereqs" steps. Execute this trigger to copy the Helm Charts and Container Images out of JFrog and into Google Artifacts.

**This step will take a few hours to run. Some of the containers are quite large in size and takes a while to pull from Artifactory.**