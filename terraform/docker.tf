# ==============================================================================
# Docker Network
# ==============================================================================

resource "docker_network" "media_network" {
  name   = local.docker_network_name
  driver = "bridge"
  
  ipam_config {
    subnet  = "172.20.0.0/16"
    gateway = "172.20.0.1"
  }

  lifecycle {
    prevent_destroy = true
  }
}

# ==============================================================================
# Docker Images
# ==============================================================================

resource "docker_image" "twingate_connector" {
  name         = "twingate/connector:latest"
  keep_locally = false

  lifecycle {
    ignore_changes = [name]
  }
}

resource "docker_image" "radarr" {
  name         = "linuxserver/radarr:latest"
  keep_locally = false

  lifecycle {
    ignore_changes = [name]
  }
}

resource "docker_image" "sonarr" {
  name         = "linuxserver/sonarr:latest"
  keep_locally = false

  lifecycle {
    ignore_changes = [name]
  }
}

resource "docker_image" "overseerr" {
  name         = "sctx/overseerr:latest"
  keep_locally = false

  lifecycle {
    ignore_changes = [name]
  }
}

resource "docker_image" "prowlarr" {
  name         = "linuxserver/prowlarr:latest"
  keep_locally = false

  lifecycle {
    ignore_changes = [name]
  }
}

resource "docker_image" "flaresolverr" {
  name         = "ghcr.io/flaresolverr/flaresolverr:latest"
  keep_locally = false

  lifecycle {
    ignore_changes = [name]
  }
}

# ==============================================================================
# Docker Containers
# ==============================================================================

resource "docker_container" "twingate_connector" {
  name    = "${local.resource_prefix}-twingate-connector"
  image   = docker_image.twingate_connector.image_id
  restart = "always"

  env = [
    "TWINGATE_NETWORK=${var.account_name}",
    "TWINGATE_ACCESS_TOKEN=${twingate_connector_tokens.nas_connector_tokens.access_token}",
    "TWINGATE_REFRESH_TOKEN=${twingate_connector_tokens.nas_connector_tokens.refresh_token}",
    "TWINGATE_LOG_ANALYTICS=v2",
    "TWINGATE_LOG_LEVEL=${var.twingate_connector_log_level}",
  ]

  sysctls = {
    "net.ipv4.ping_group_range" = "0 2147483647"
  }

  networks_advanced {
    name = docker_network.media_network.id
  }

  labels {
    label = "com.twingate.managed"
    value = "true"
  }

  labels {
    label = "project"
    value = var.project_name
  }

  labels {
    label = "environment"
    value = var.environment
  }

  depends_on = [
    docker_image.twingate_connector,
    docker_network.media_network
  ]
}

resource "docker_container" "sonarr" {
  name    = "${local.resource_prefix}-sonarr"
  image   = docker_image.sonarr.image_id
  restart = local.restart_policy

  volumes {
    host_path      = "${local.final_volume_path}/sonarr/config"
    container_path = "/config"
  }

  volumes {
    host_path      = "${local.final_volume_path}/plex/Shows"
    container_path = "/tv"
  }

  volumes {
    host_path      = "${local.final_volume_path}/downloads"
    container_path = "/downloads"
  }

  env = [
    "TZ=${var.timezone}",
    "PUID=1000",
    "PGID=1000",
  ]

  ports {
    internal = local.media_service_ports.sonarr
    external = local.media_service_ports.sonarr
  }

  networks_advanced {
    name = docker_network.media_network.id
  }

  labels {
    label = "project"
    value = var.project_name
  }

  labels {
    label = "environment"
    value = var.environment
  }

  labels {
    label = "service"
    value = "sonarr"
  }

  depends_on = [
    docker_image.sonarr,
    docker_network.media_network
  ]
}

resource "docker_container" "radarr" {
  name    = "${local.resource_prefix}-radarr"
  image   = docker_image.radarr.image_id
  restart = local.restart_policy

  volumes {
    host_path      = "${local.final_volume_path}/radarr/config"
    container_path = "/config"
  }

  volumes {
    host_path      = "${local.final_volume_path}/plex/Movies"
    container_path = "/movies"
  }

  volumes {
    host_path      = "${local.final_volume_path}/downloads"
    container_path = "/downloads"
  }

  env = [
    "TZ=${var.timezone}",
    "PUID=1000",
    "PGID=1000",
  ]

  ports {
    internal = local.media_service_ports.radarr
    external = local.media_service_ports.radarr
  }

  networks_advanced {
    name = docker_network.media_network.id
  }

  labels {
    label = "project"
    value = var.project_name
  }

  labels {
    label = "environment"
    value = var.environment
  }

  labels {
    label = "service"
    value = "radarr"
  }

  depends_on = [
    docker_image.radarr,
    docker_network.media_network
  ]
}

resource "docker_container" "overseerr" {
  name    = "${local.resource_prefix}-overseerr"
  image   = docker_image.overseerr.image_id
  restart = local.restart_policy

  env = [
    "LOG_LEVEL=info",
    "TZ=${var.timezone}",
  ]

  ports {
    internal = local.media_service_ports.overseerr
    external = local.media_service_ports.overseerr
  }

  volumes {
    host_path      = "${local.final_volume_path}/overseerr/config"
    container_path = "/app/config"
  }

  networks_advanced {
    name = docker_network.media_network.id
  }

  labels {
    label = "project"
    value = var.project_name
  }

  labels {
    label = "environment"
    value = var.environment
  }

  labels {
    label = "service"
    value = "overseerr"
  }

  depends_on = [
    docker_image.overseerr,
    docker_network.media_network
  ]
}

resource "docker_container" "prowlarr" {
  name    = "${local.resource_prefix}-prowlarr"
  image   = docker_image.prowlarr.image_id
  restart = local.restart_policy

  volumes {
    host_path      = "${local.final_volume_path}/prowlarr/config"
    container_path = "/config"
  }

  env = [
    "TZ=${var.timezone}",
    "PUID=1000",
    "PGID=1000",
  ]

  ports {
    internal = local.media_service_ports.prowlarr
    external = local.media_service_ports.prowlarr
  }

  networks_advanced {
    name = docker_network.media_network.id
  }

  labels {
    label = "project"
    value = var.project_name
  }

  labels {
    label = "environment"
    value = var.environment
  }

  labels {
    label = "service"
    value = "prowlarr"
  }

  depends_on = [
    docker_image.prowlarr,
    docker_network.media_network
  ]
}

resource "docker_container" "flaresolverr" {
  name    = "${local.resource_prefix}-flaresolverr"
  image   = docker_image.flaresolverr.image_id
  restart = local.restart_policy

  volumes {
    host_path      = "${local.final_volume_path}/flaresolverr/config"
    container_path = "/config"
  }

  env = [
    "LOG_LEVEL=info",
    "TZ=${var.timezone}",
  ]

  ports {
    internal = local.media_service_ports.flaresolverr
    external = local.media_service_ports.flaresolverr
  }

  networks_advanced {
    name = docker_network.media_network.id
  }

  labels {
    label = "project"
    value = var.project_name
  }

  labels {
    label = "environment"
    value = var.environment
  }

  labels {
    label = "service"
    value = "flaresolverr"
  }

  depends_on = [
    docker_image.flaresolverr,
    docker_network.media_network
  ]
}
