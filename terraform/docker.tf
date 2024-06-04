resource "docker_image" "twingate_connector" {
  name = "twingate/connector:latest"
}
resource "docker_image" "radarr" {
  name = "linuxserver/radarr:latest"
}
resource "docker_image" "sonarr" {
  name = "linuxserver/sonarr:latest"
}
resource "docker_image" "overseerr" {
  name = "sctx/overseerr:latest"
}
resource "docker_image" "prowlarr" {
  name = "linuxserver/prowlarr:latest"
}
resource "docker_image" "flaresolverr" {
  name = "ghcr.io/flaresolverr/flaresolverr:latest"
}

resource "docker_container" "twingate_connector" {
  name  = "twingate_connector"
  image = docker_image.twingate_connector.image_id
  restart = "always"

  env = [
    "TWINGATE_NETWORK=${var.account_name}",
    "TWINGATE_ACCESS_TOKEN=${twingate_connector_tokens.nas_connector_tokens.access_token}",
    "TWINGATE_REFRESH_TOKEN=${twingate_connector_tokens.nas_connector_tokens.refresh_token}",
    "TWINGATE_LOG_ANALYTICS=v2",
    "TWINGATE_LOG_LEVEL=3",
  ]

  sysctls = {
    "net.ipv4.ping_group_range" = "0 2147483647"
  }
  depends_on = [docker_image.twingate_connector]
}

resource "docker_container" "sonarr" {
  image = docker_image.sonarr.image_id
  name  = "sonarr"
  volumes {
    host_path      = "${local.final_volume_path}/sonarr/config"
    container_path = "/config"
  }
  volumes {
    host_path      = "${local.final_volume_path}/plex/Shows"
    container_path = "/tv"
  }

  env = [
    "TZ=${var.timezone}"
  ]

  ports {
    internal = 8989
    external = 8989
  }
}

resource "docker_container" "radarr" {
  image = docker_image.radarr.image_id
  name  = "radarr"
  volumes {
    host_path      = "${local.final_volume_path}/radarr/config"
    container_path = "/config"
  }
  volumes {
    host_path      = "${local.final_volume_path}/plex/Movies"
    container_path = "/movies"
  }

  env = [
    "TZ=${var.timezone}"
  ]

  ports {
    internal = 7878
    external = 7878
  }
}

resource "docker_container" "overseerr" {
  image = docker_image.overseerr.image_id
  name  = "overseerr"

  env = [
    "LOG_LEVEL=info",
    "TZ=${var.timezone}"
  ]

  ports {
    internal = 5055
    external = 5055
  }

  volumes {
    host_path      = "${local.final_volume_path}/overseerr/config"
    container_path = "/app/config"
  }

  restart = "unless-stopped"
}

resource "docker_container" "prowlarr" {
  image = docker_image.prowlarr.image_id
  name  = "prowlarr"

  volumes {
    host_path      = "${local.final_volume_path}/prowlarr/config"
    container_path = "/config"
  }

  env = [
    "TZ = ${var.timezone}"
  ]

  ports {
    internal = 9696
    external = 9696
  }

  restart = "always"
}

resource "docker_container" "flaresolverr" {
  image = docker_image.flaresolverr.image_id
  name  = "flaresolverr"

  volumes {
    host_path      = "${local.final_volume_path}/flaresolverr/config"
    container_path = "/config"
  }

  env = [
    "LOG_LEVEL = info",
    "TZ        = ${var.timezone}"
  ]

  ports {
    internal = 8191
    external = 8191
  }

  restart = "always"
}
