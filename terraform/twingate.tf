# ==============================================================================
# Twingate Remote Network Configuration
# ==============================================================================

resource "twingate_remote_network" "nas_network" {
  name = local.twingate_network_name

  lifecycle {
    prevent_destroy = true
    ignore_changes  = [location]
  }
}

# ==============================================================================
# Data Sources
# ==============================================================================

data "twingate_group" "admin" {
  id = var.group_id
}

data "twingate_security_policy" "admin" {
  name = "Admin policy"
}

# ==============================================================================
# Twingate Connector
# ==============================================================================

resource "twingate_connector" "nas_connector" {
  remote_network_id      = twingate_remote_network.nas_network.id
  name                   = local.twingate_connector_name
  status_updates_enabled = true

  lifecycle {
    create_before_destroy = true
  }
}

resource "twingate_connector_tokens" "nas_connector_tokens" {
  connector_id = twingate_connector.nas_connector.id

  lifecycle {
    create_before_destroy = true
    ignore_changes        = [access_token, refresh_token]
  }
}

# ==============================================================================
# Twingate Resources - Media Services
# ==============================================================================

resource "twingate_resource" "overseerr" {
  name                   = "${local.resource_prefix}-overseerr"
  address                = docker_container.overseerr.network_data[0].ip_address
  alias                  = "media.mania"
  remote_network_id      = twingate_remote_network.nas_network.id
  security_policy_id     = data.twingate_security_policy.admin.id
  is_active              = true
  is_visible             = true
  is_browser_shortcut_enabled = true

  protocols {
    allow_icmp = false
    tcp {
      policy = "RESTRICTED"
      ports  = [tostring(local.media_service_ports.overseerr)]
    }
    udp {
      policy = "DENY_ALL"
    }
  }

  access {
    group_ids          = [data.twingate_group.admin.id]
    security_policy_id = data.twingate_security_policy.admin.id
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes        = [address]
  }

  depends_on = [
    docker_container.overseerr,
    twingate_connector.nas_connector
  ]
}

resource "twingate_resource" "sonarr" {
  name                   = "${local.resource_prefix}-sonarr"
  address                = docker_container.sonarr.network_data[0].ip_address
  remote_network_id      = twingate_remote_network.nas_network.id
  security_policy_id     = data.twingate_security_policy.admin.id
  is_active              = true
  is_visible             = true

  protocols {
    allow_icmp = false
    tcp {
      policy = "RESTRICTED"
      ports  = [tostring(local.media_service_ports.sonarr)]
    }
    udp {
      policy = "DENY_ALL"
    }
  }

  access {
    group_ids          = [data.twingate_group.admin.id]
    security_policy_id = data.twingate_security_policy.admin.id
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes        = [address]
  }

  depends_on = [
    docker_container.sonarr,
    twingate_connector.nas_connector
  ]
}

resource "twingate_resource" "radarr" {
  name                   = "${local.resource_prefix}-radarr"
  address                = docker_container.radarr.network_data[0].ip_address
  remote_network_id      = twingate_remote_network.nas_network.id
  security_policy_id     = data.twingate_security_policy.admin.id
  is_active              = true
  is_visible             = true

  protocols {
    allow_icmp = false
    tcp {
      policy = "RESTRICTED"
      ports  = [tostring(local.media_service_ports.radarr)]
    }
    udp {
      policy = "DENY_ALL"
    }
  }

  access {
    group_ids          = [data.twingate_group.admin.id]
    security_policy_id = data.twingate_security_policy.admin.id
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes        = [address]
  }

  depends_on = [
    docker_container.radarr,
    twingate_connector.nas_connector
  ]
}

resource "twingate_resource" "prowlarr" {
  name                   = "${local.resource_prefix}-prowlarr"
  address                = docker_container.prowlarr.network_data[0].ip_address
  remote_network_id      = twingate_remote_network.nas_network.id
  security_policy_id     = data.twingate_security_policy.admin.id
  is_active              = true
  is_visible             = true

  protocols {
    allow_icmp = false
    tcp {
      policy = "RESTRICTED"
      ports  = [tostring(local.media_service_ports.prowlarr)]
    }
    udp {
      policy = "DENY_ALL"
    }
  }

  access {
    group_ids          = [data.twingate_group.admin.id]
    security_policy_id = data.twingate_security_policy.admin.id
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes        = [address]
  }

  depends_on = [
    docker_container.prowlarr,
    twingate_connector.nas_connector
  ]
}