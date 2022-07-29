# Creating CloudBuild Triggers

resource "google_cloudbuild_trigger" "pe-builder" {
  project = var.project_id
  name = "0-Create-PrivateEdition-Builder"

  source_to_build {
    uri       = "https://github.com/jonathanmabrito/multicloud-quickstart"
    ref       = "refs/heads/development"
    repo_type = "GITHUB"
  }

  git_file_source {
    path      = "cloudbuild-builder.yaml"
    uri       = "https://github.com/jonathanmabrito/multicloud-quickstart"
    revision  = "refs/heads/development"
    repo_type = "GITHUB"
  }

  approval_config {
    approval_required = false
  }
}

resource "google_cloudbuild_trigger" "gcp-platform" {
  project = var.project_id
  name = "1-Provision-GCP-Platform"

  source_to_build {
    uri       = "https://github.com/jonathanmabrito/multicloud-quickstart"
    ref       = "refs/heads/development"
    repo_type = "GITHUB"
  }

  git_file_source {
    path      = "cloudbuild-gcp-platform.yaml"
    uri       = "https://github.com/jonathanmabrito/multicloud-quickstart"
    revision  = "refs/heads/development"
    repo_type = "GITHUB"
  }

  approval_config {
    approval_required = false
  }

  substitutions = {
    _VGCPREGIONPRIMARY    = var.gkeregionprimary
    _VGCPREGIONSECONDARY  = var.gkeregionsecondary
    _VGCPPROJECT          = var.project_id
    _VGKECLUSTER          = var.gkecluster
    _VDOMAIN              = var.fqdn
    _VEMAILADDRESS        = var.emailaddress
    _VSTORAGEBUCKET       = var.storageBucketName
  }
}

resource "google_cloudbuild_trigger" "services-infra" {
  project = var.project_id
  name = "2-Provision-PrivateEdition-Applications-INFRA"

  source_to_build {
    uri       = "https://github.com/jonathanmabrito/multicloud-quickstart"
    ref       = "refs/heads/development"
    repo_type = "GITHUB"
  }

  git_file_source {
    path      = "cloudbuild-services-infra.yaml"
    uri       = "https://github.com/jonathanmabrito/multicloud-quickstart"
    revision  = "refs/heads/development"
    repo_type = "GITHUB"
  }

  approval_config {
    approval_required = false
  }

  substitutions = {
    _VDOMAIN      = var.fqdn
    _VGCPPROJECT  = var.project_id
    _VGCPREGION   = var.gkeregionprimary
    _VGKECLUSTER  = var.gkecluster
    _VHELMCOMMAND = "install"
  }
}

resource "google_cloudbuild_trigger" "services-gauth" {
  project = var.project_id
  name = "3-Provision-PrivateEdition-Applications-GAUTH"

  source_to_build {
    uri       = "https://github.com/jonathanmabrito/multicloud-quickstart"
    ref       = "refs/heads/development"
    repo_type = "GITHUB"
  }

  git_file_source {
    path      = "cloudbuild-services-gauth.yaml"
    uri       = "https://github.com/jonathanmabrito/multicloud-quickstart"
    revision  = "refs/heads/development"
    repo_type = "GITHUB"
  }

  approval_config {
    approval_required = false
  }

  substitutions = {
    _VARTIFACTREPO  = "oci://us-west2-docker.pkg.dev/gts-multicloud-pe-dev/gts-multicloud-pe"   
    _VDOMAIN        = var.fqdn
    _VGCPPROJECT    = var.project_id
    _VGCPREGION     = var.gkeregionprimary
    _VGKECLUSTER    = var.gkecluster
    _VHELMCOMMAND   = "install"
    _VIMAGEREGISTRY = "gcr.io/gts-multicloud-pe-dev/gts-multicloud-pe"
  }
}

resource "google_cloudbuild_trigger" "services-voice" {
  project = var.project_id
  name = "4-Provision-PrivateEdition-Applications-VOICE"

  source_to_build {
    uri       = "https://github.com/jonathanmabrito/multicloud-quickstart"
    ref       = "refs/heads/development"
    repo_type = "GITHUB"
  }

  git_file_source {
    path      = "cloudbuild-services-voice.yaml"
    uri       = "https://github.com/jonathanmabrito/multicloud-quickstart"
    revision  = "refs/heads/development"
    repo_type = "GITHUB"
  }

  approval_config {
    approval_required = false
  }

  substitutions = {
    _VARTIFACTREPO  = "oci://us-west2-docker.pkg.dev/gts-multicloud-pe-dev/gts-multicloud-pe"   
    _VDOMAIN        = var.fqdn
    _VGCPPROJECT    = var.project_id
    _VGCPREGION     = var.gkeregionprimary
    _VGKECLUSTER    = var.gkecluster
    _VHELMCOMMAND   = "install"
    _VIMAGEREGISTRY = "gcr.io/gts-multicloud-pe-dev/gts-multicloud-pe"
  }
}

resource "google_cloudbuild_trigger" "services-tenant" {
  project = var.project_id
  name = "5-Provision-PrivateEdition-Applications-TENANT"

  source_to_build {
    uri       = "https://github.com/jonathanmabrito/multicloud-quickstart"
    ref       = "refs/heads/development"
    repo_type = "GITHUB"
  }

  git_file_source {
    path      = "cloudbuild-services-tenant.yaml"
    uri       = "https://github.com/jonathanmabrito/multicloud-quickstart"
    revision  = "refs/heads/development"
    repo_type = "GITHUB"
  }

  approval_config {
    approval_required = false
  }

  substitutions = {
    _VARTIFACTREPO  = "oci://us-west2-docker.pkg.dev/gts-multicloud-pe-dev/gts-multicloud-pe"   
    _VDOMAIN        = var.fqdn
    _VGCPPROJECT    = var.project_id
    _VGCPREGION     = var.gkeregionprimary
    _VGKECLUSTER    = var.gkecluster
    _VHELMCOMMAND   = "install"
    _VIMAGEREGISTRY = "gcr.io/gts-multicloud-pe-dev/gts-multicloud-pe"
  }
}


resource "google_cloudbuild_trigger" "services-gws" {
  project = var.project_id
  name = "6-Provision-PrivateEdition-Applications-GWS"

  source_to_build {
    uri       = "https://github.com/jonathanmabrito/multicloud-quickstart"
    ref       = "refs/heads/development"
    repo_type = "GITHUB"
  }

  git_file_source {
    path      = "cloudbuild-services-gws.yaml"
    uri       = "https://github.com/jonathanmabrito/multicloud-quickstart"
    revision  = "refs/heads/development"
    repo_type = "GITHUB"
  }

  approval_config {
    approval_required = false
  }

  substitutions = {
    _VARTIFACTREPO  = "oci://us-west2-docker.pkg.dev/gts-multicloud-pe-dev/gts-multicloud-pe"   
    _VDOMAIN        = var.fqdn
    _VGCPPROJECT    = var.project_id
    _VGCPREGION     = var.gkeregionprimary
    _VGKECLUSTER    = var.gkecluster
    _VHELMCOMMAND   = "install"
    _VIMAGEREGISTRY = "gcr.io/gts-multicloud-pe-dev/gts-multicloud-pe"
  }
}

resource "google_cloudbuild_trigger" "services-wwe" {
  project = var.project_id
  name = "7-Provision-PrivateEdition-Applications-WWE"

  source_to_build {
    uri       = "https://github.com/jonathanmabrito/multicloud-quickstart"
    ref       = "refs/heads/development"
    repo_type = "GITHUB"
  }

  git_file_source {
    path      = "cloudbuild-services-wwe.yaml"
    uri       = "https://github.com/jonathanmabrito/multicloud-quickstart"
    revision  = "refs/heads/development"
    repo_type = "GITHUB"
  }

  approval_config {
    approval_required = false
  }

  substitutions = {
    _VARTIFACTREPO  = "oci://us-west2-docker.pkg.dev/gts-multicloud-pe-dev/gts-multicloud-pe"   
    _VDOMAIN        = var.fqdn
    _VGCPPROJECT    = var.project_id
    _VGCPREGION     = var.gkeregionprimary
    _VGKECLUSTER    = var.gkecluster
    _VHELMCOMMAND   = "install"
    _VIMAGEREGISTRY = "gcr.io/gts-multicloud-pe-dev/gts-multicloud-pe"
  }
}

resource "google_cloudbuild_trigger" "services-webrtc" {
  project = var.project_id
  name = "8-Provision-PrivateEdition-Applications-WebRTC"

  source_to_build {
    uri       = "https://github.com/jonathanmabrito/multicloud-quickstart"
    ref       = "refs/heads/development"
    repo_type = "GITHUB"
  }

  git_file_source {
    path      = "cloudbuild-services-webrtc.yaml"
    uri       = "https://github.com/jonathanmabrito/multicloud-quickstart"
    revision  = "refs/heads/development"
    repo_type = "GITHUB"
  }

  approval_config {
    approval_required = false
  }

  substitutions = {
    _VARTIFACTREPO  = "oci://us-west2-docker.pkg.dev/gts-multicloud-pe-dev/gts-multicloud-pe"   
    _VDOMAIN        = var.fqdn
    _VGCPPROJECT    = var.project_id
    _VGCPREGION     = var.gkeregionprimary
    _VGKECLUSTER    = var.gkecluster
    _VHELMCOMMAND   = "install"
    _VIMAGEREGISTRY = "gcr.io/gts-multicloud-pe-dev/gts-multicloud-pe"
  }
}

resource "google_cloudbuild_trigger" "services-designer" {
  project = var.project_id
  name = "9-Provision-PrivateEdition-Applications-Designer"

  source_to_build {
    uri       = "https://github.com/jonathanmabrito/multicloud-quickstart"
    ref       = "refs/heads/development"
    repo_type = "GITHUB"
  }

  git_file_source {
    path      = "cloudbuild-services-designer.yaml"
    uri       = "https://github.com/jonathanmabrito/multicloud-quickstart"
    revision  = "refs/heads/development"
    repo_type = "GITHUB"
  }

  approval_config {
    approval_required = false
  }

  substitutions = {
    _VARTIFACTREPO  = "oci://us-west2-docker.pkg.dev/gts-multicloud-pe-dev/gts-multicloud-pe"   
    _VDOMAIN        = var.fqdn
    _VGCPPROJECT    = var.project_id
    _VGCPREGION     = var.gkeregionprimary
    _VGKECLUSTER    = var.gkecluster
    _VHELMCOMMAND   = "install"
    _VIMAGEREGISTRY = "gcr.io/gts-multicloud-pe-dev/gts-multicloud-pe"
  }
}

resource "google_cloudbuild_trigger" "services-gvp" {
  project = var.project_id
  name = "10-Provision-PrivateEdition-Applications-GVP"

  source_to_build {
    uri       = "https://github.com/jonathanmabrito/multicloud-quickstart"
    ref       = "refs/heads/development"
    repo_type = "GITHUB"
  }

  git_file_source {
    path      = "cloudbuild-services-gvp.yaml"
    uri       = "https://github.com/jonathanmabrito/multicloud-quickstart"
    revision  = "refs/heads/development"
    repo_type = "GITHUB"
  }

  approval_config {
    approval_required = false
  }

  substitutions = {
    _VARTIFACTREPO  = "oci://us-west2-docker.pkg.dev/gts-multicloud-pe-dev/gts-multicloud-pe"   
    _VDOMAIN        = var.fqdn
    _VGCPPROJECT    = var.project_id
    _VGCPREGION     = var.gkeregionprimary
    _VGKECLUSTER    = var.gkecluster
    _VHELMCOMMAND   = "install"
    _VIMAGEREGISTRY = "gcr.io/gts-multicloud-pe-dev/gts-multicloud-pe"
  }
}

resource "google_cloudbuild_trigger" "services-gsp" {
  project = var.project_id
  name = "11-Provision-PrivateEdition-Applications-GSP"

  source_to_build {
    uri       = "https://github.com/jonathanmabrito/multicloud-quickstart"
    ref       = "refs/heads/development"
    repo_type = "GITHUB"
  }

  git_file_source {
    path      = "cloudbuild-services-gsp.yaml"
    uri       = "https://github.com/jonathanmabrito/multicloud-quickstart"
    revision  = "refs/heads/development"
    repo_type = "GITHUB"
  }

  approval_config {
    approval_required = false
  }

  substitutions = {
    _VARTIFACTREPO  = "oci://us-west2-docker.pkg.dev/gts-multicloud-pe-dev/gts-multicloud-pe"   
    _VDOMAIN        = var.fqdn
    _VGCPPROJECT    = var.project_id
    _VGCPREGION     = var.gkeregionprimary
    _VGKECLUSTER    = var.gkecluster
    _VHELMCOMMAND   = "install"
    _VIMAGEREGISTRY = "gcr.io/gts-multicloud-pe-dev/gts-multicloud-pe"
  }
}

resource "google_cloudbuild_trigger" "services-gim" {
  project = var.project_id
  name = "12-Provision-PrivateEdition-Applications-GIM"

  source_to_build {
    uri       = "https://github.com/jonathanmabrito/multicloud-quickstart"
    ref       = "refs/heads/development"
    repo_type = "GITHUB"
  }

  git_file_source {
    path      = "cloudbuild-services-gim.yaml"
    uri       = "https://github.com/jonathanmabrito/multicloud-quickstart"
    revision  = "refs/heads/development"
    repo_type = "GITHUB"
  }

  approval_config {
    approval_required = false
  }

  substitutions = {
    _VARTIFACTREPO  = "oci://us-west2-docker.pkg.dev/gts-multicloud-pe-dev/gts-multicloud-pe"   
    _VDOMAIN        = var.fqdn
    _VGCPPROJECT    = var.project_id
    _VGCPREGION     = var.gkeregionprimary
    _VGKECLUSTER    = var.gkecluster
    _VHELMCOMMAND   = "install"
    _VIMAGEREGISTRY = "gcr.io/gts-multicloud-pe-dev/gts-multicloud-pe"
  }
}

resource "google_cloudbuild_trigger" "services-gca" {
  project = var.project_id
  name = "13-Provision-PrivateEdition-Applications-GCA"

  source_to_build {
    uri       = "https://github.com/jonathanmabrito/multicloud-quickstart"
    ref       = "refs/heads/development"
    repo_type = "GITHUB"
  }

  git_file_source {
    path      = "cloudbuild-services-gca.yaml"
    uri       = "https://github.com/jonathanmabrito/multicloud-quickstart"
    revision  = "refs/heads/development"
    repo_type = "GITHUB"
  }

  approval_config {
    approval_required = false
  }

  substitutions = {
    _VARTIFACTREPO  = "oci://us-west2-docker.pkg.dev/gts-multicloud-pe-dev/gts-multicloud-pe"   
    _VDOMAIN        = var.fqdn
    _VGCPPROJECT    = var.project_id
    _VGCPREGION     = var.gkeregionprimary
    _VGKECLUSTER    = var.gkecluster
    _VHELMCOMMAND   = "install"
    _VIMAGEREGISTRY = "gcr.io/gts-multicloud-pe-dev/gts-multicloud-pe"
  }
}

resource "google_cloudbuild_trigger" "services-ucsx" {
  project = var.project_id
  name = "14-Provision-PrivateEdition-Applications-UCSX"

  source_to_build {
    uri       = "https://github.com/jonathanmabrito/multicloud-quickstart"
    ref       = "refs/heads/development"
    repo_type = "GITHUB"
  }

  git_file_source {
    path      = "cloudbuild-services-ucsx.yaml"
    uri       = "https://github.com/jonathanmabrito/multicloud-quickstart"
    revision  = "refs/heads/development"
    repo_type = "GITHUB"
  }

  approval_config {
    approval_required = false
  }

  substitutions = {
    _VARTIFACTREPO  = "oci://us-west2-docker.pkg.dev/gts-multicloud-pe-dev/gts-multicloud-pe"   
    _VDOMAIN        = var.fqdn
    _VGCPPROJECT    = var.project_id
    _VGCPREGION     = var.gkeregionprimary
    _VGKECLUSTER    = var.gkecluster
    _VHELMCOMMAND   = "install"
    _VIMAGEREGISTRY = "gcr.io/gts-multicloud-pe-dev/gts-multicloud-pe"
  }
}

resource "google_cloudbuild_trigger" "services-nexus" {
  project = var.project_id
  name = "15-Provision-PrivateEdition-Applications-NEXUS"

  source_to_build {
    uri       = "https://github.com/jonathanmabrito/multicloud-quickstart"
    ref       = "refs/heads/development"
    repo_type = "GITHUB"
  }

  git_file_source {
    path      = "cloudbuild-services-nexus.yaml"
    uri       = "https://github.com/jonathanmabrito/multicloud-quickstart"
    revision  = "refs/heads/development"
    repo_type = "GITHUB"
  }

  approval_config {
    approval_required = false
  }

  substitutions = {
    _VARTIFACTREPO  = "oci://us-west2-docker.pkg.dev/gts-multicloud-pe-dev/gts-multicloud-pe"   
    _VDOMAIN        = var.fqdn
    _VGCPPROJECT    = var.project_id
    _VGCPREGION     = var.gkeregionprimary
    _VGKECLUSTER    = var.gkecluster
    _VHELMCOMMAND   = "install"
    _VIMAGEREGISTRY = "gcr.io/gts-multicloud-pe-dev/gts-multicloud-pe"
  }
}

resource "google_cloudbuild_trigger" "services-iwd" {
  project = var.project_id
  name = "16-Provision-PrivateEdition-Applications-IWD"

  source_to_build {
    uri       = "https://github.com/jonathanmabrito/multicloud-quickstart"
    ref       = "refs/heads/development"
    repo_type = "GITHUB"
  }

  git_file_source {
    path      = "cloudbuild-services-iwd.yaml"
    uri       = "https://github.com/jonathanmabrito/multicloud-quickstart"
    revision  = "refs/heads/development"
    repo_type = "GITHUB"
  }

  approval_config {
    approval_required = false
  }

  substitutions = {
    _VARTIFACTREPO  = "oci://us-west2-docker.pkg.dev/gts-multicloud-pe-dev/gts-multicloud-pe"   
    _VDOMAIN        = var.fqdn
    _VGCPPROJECT    = var.project_id
    _VGCPREGION     = var.gkeregionprimary
    _VGKECLUSTER    = var.gkecluster
    _VHELMCOMMAND   = "install"
    _VIMAGEREGISTRY = "gcr.io/gts-multicloud-pe-dev/gts-multicloud-pe"
  }
}

resource "google_cloudbuild_trigger" "services-cxc" {
  project = var.project_id
  name = "17-Provision-PrivateEdition-Applications-CXC"

  source_to_build {
    uri       = "https://github.com/jonathanmabrito/multicloud-quickstart"
    ref       = "refs/heads/development"
    repo_type = "GITHUB"
  }

  git_file_source {
    path      = "cloudbuild-services-cxc.yaml"
    uri       = "https://github.com/jonathanmabrito/multicloud-quickstart"
    revision  = "refs/heads/development"
    repo_type = "GITHUB"
  }

  approval_config {
    approval_required = false
  }

  substitutions = {
    _VARTIFACTREPO  = "oci://us-west2-docker.pkg.dev/gts-multicloud-pe-dev/gts-multicloud-pe"   
    _VDOMAIN        = var.fqdn
    _VGCPPROJECT    = var.project_id
    _VGCPREGION     = var.gkeregionprimary
    _VGKECLUSTER    = var.gkecluster
    _VHELMCOMMAND   = "install"
    _VIMAGEREGISTRY = "gcr.io/gts-multicloud-pe-dev/gts-multicloud-pe"
  }
}