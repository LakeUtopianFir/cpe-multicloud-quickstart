# Consul namespace creation
resource "kubernetes_namespace" consul {
  metadata {
    name = "consul"
  }
}

# Helm Value for Consul
data "local_file" "helmvalues-consul" {
  filename = "${path.module}/consul-values.yaml"
}

resource "helm_release" "consul" {
  name          = "consul"
  repository    = "https://helm.releases.hashicorp.com"
  chart         = "consul"
  namespace     = "consul"
  timeout       = 1000
  atomic        = true
  max_history   = 10
  wait          = true
  recreate_pods = true
  version       =  var.consul_helm_version
  values        = [
    data.local_file.helmvalues-consul.content
  ]
  depends_on = [
    kubernetes_namespace.consul,
  ]
}

# Kafka namespace creation
resource "kubernetes_namespace" "kafka" {
  metadata {
    name = "kafka"
  }
}

data "local_file" "helmvalues-kafka" {
  filename = "${path.module}/kafka-values.yaml"
}

resource "helm_release" "kafka-install" {
  name        = "kafka-helm"
  repository  = "https://confluentinc.github.io/cp-helm-charts/"
  chart       = "cp-helm-charts"
  namespace   = "kafka"
  timeout     = 1000
  atomic      = true
  version     = var.kafka_helm_version
  values      = [
    data.local_file.helmvalues-kafka.content
  ]
  depends_on  = [
    kubernetes_namespace.kafka,helm_release.consul
  ]
}

# Keda namespace creation
resource "kubernetes_namespace" "keda" {
  metadata {
    name = "keda"
  }
}

resource "helm_release" "keda" {
  name        = "keda"
  repository  = "https://kedacore.github.io/charts"
  chart       = "keda"
  namespace   = "keda"
  timeout     = 1000
  atomic      = true
  version     = var.keda_helm_version
  depends_on  = [
  kubernetes_namespace.keda,helm_release.consul
  ]
}

# Infra namespace creation
resource "kubernetes_namespace" "infra" {
  metadata {
    name = "infra"
  }
}

# Helm Value for MSSQL
data "local_file" "helmvalues-mssql" {
  filename = "${path.module}/mssql-values.yaml"
}

resource "helm_release" "mssql" {
  name          = "mssql"
  repository    = "https://simcubeltd.github.io/simcube-helm-charts"
  chart         = "mssqlserver-2019"
  namespace     = "infra"
  timeout       = 1000
  atomic        = true
  max_history   = 10
  wait          = true
  recreate_pods = true
  version       =  var.mssql_helm_version
  values        = [
    data.local_file.helmvalues-mssql.content
  ]
  depends_on = [
    kubernetes_namespace.infra,
  ]
}

# Helm Value for Prometheus
data "local_file" "helmvalues-prometheus" {
  filename = "${path.module}/prometheus-values.yaml"
}

resource "helm_release" "prometheus" {
  name          = "prometheus"
  repository    = "https://prometheus-community.github.io/helm-charts"
  chart         = "kube-prometheus-stack"
  namespace     = "infra"
  timeout       = 1000
  atomic        = true
  max_history   = 10
  wait          = true
  recreate_pods = true
  version       =  var.prometheus_helm_version
  values        = [
    data.local_file.helmvalues-prometheus.content
  ]
  depends_on = [
    kubernetes_namespace.infra,
  ]
}