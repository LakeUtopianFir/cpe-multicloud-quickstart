# Configure port-frward for consul to inject config
#resource "null_resource" "consul-port-forward" {
#  provisioner "local-exec" {
#    command = "kubectl port-forward svc/consul-server 8500:8500 -n consul > /dev/null 2>&1 &"
#  }
#}

# Create consul intentation to allow all-to-all connectivity
resource "consul_config_entry" "service_intentions" {
      name = "*"
      kind = "service-intentions"
      #depends_on = [null_resource.consul-port-forward]
      config_json = jsonencode({
        Sources = [
          {
            Name: "*",
            Action: "allow",
            Precedence: 5,
            Type: "consul"
          }
        ]
      })
    }

# No need to kill pid for port-forward as it only exists within this session