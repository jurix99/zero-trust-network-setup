resource "twingate_remote_network" "nas_network" {
  name = "nas_remote_network"
}

data "twingate_group" "admin" {
  id = "${var.group_id}"
}

data "twingate_security_policy" "admin" {
  id = "${var.policy_id}"
}

resource "twingate_resource" "resource" {
  name = "radians-resource-1"
  address = "127.0.0.1"
  alias = "radians.fr"
  remote_network_id = twingate_remote_network.nas_network.id

  security_policy_id = data.twingate_security_policy.admin.id

  protocols = {
    allow_icmp = true
    tcp = {
      policy = "RESTRICTED"
      ports = ["80"]
    }
    udp = {
      policy = "DENY_ALL"
    }
  }

  dynamic "access_group" {
    for_each = [data.twingate_group.admin.id]
    content {
      group_id = access_group.value
      security_policy_id = data.twingate_security_policy.admin.id
      usage_based_autolock_duration_days = 30
    }
  }

  is_active = true
}