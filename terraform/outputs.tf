# ==============================================================================
# Twingate Outputs
# ==============================================================================

output "twingate_remote_network_id" {
  description = "The ID of the Twingate remote network"
  value       = twingate_remote_network.nas_network.id
}

output "twingate_remote_network_name" {
  description = "The name of the Twingate remote network"
  value       = twingate_remote_network.nas_network.name
}

output "twingate_connector_id" {
  description = "The ID of the Twingate connector"
  value       = twingate_connector.nas_connector.id
}

output "twingate_connector_name" {
  description = "The name of the Twingate connector"
  value       = twingate_connector.nas_connector.name
}

output "twingate_resource_ids" {
  description = "Map of Twingate resource names to their IDs"
  value = {
    overseerr = twingate_resource.overseerr.id
    sonarr    = twingate_resource.sonarr.id
    radarr    = twingate_resource.radarr.id
    prowlarr  = twingate_resource.prowlarr.id
  }
}

output "twingate_resource_addresses" {
  description = "Map of service names to their Twingate access addresses"
  value = {
    overseerr = "${twingate_resource.overseerr.alias}"
    sonarr    = "${twingate_resource.sonarr.name}"
    radarr    = "${twingate_resource.radarr.name}"
    prowlarr  = "${twingate_resource.prowlarr.name}"
  }
}

# ==============================================================================
# Docker Outputs
# ==============================================================================

output "docker_network_id" {
  description = "The ID of the Docker network"
  value       = docker_network.media_network.id
}

output "docker_network_name" {
  description = "The name of the Docker network"
  value       = docker_network.media_network.name
}

output "docker_container_ids" {
  description = "Map of container names to their IDs"
  value = {
    twingate_connector = docker_container.twingate_connector.id
    overseerr          = docker_container.overseerr.id
    sonarr             = docker_container.sonarr.id
    radarr             = docker_container.radarr.id
    prowlarr           = docker_container.prowlarr.id
    flaresolverr       = docker_container.flaresolverr.id
  }
}

output "docker_container_ips" {
  description = "Map of container names to their IP addresses"
  value = {
    twingate_connector = try(docker_container.twingate_connector.network_data[0].ip_address, "N/A")
    overseerr          = try(docker_container.overseerr.network_data[0].ip_address, "N/A")
    sonarr             = try(docker_container.sonarr.network_data[0].ip_address, "N/A")
    radarr             = try(docker_container.radarr.network_data[0].ip_address, "N/A")
    prowlarr           = try(docker_container.prowlarr.network_data[0].ip_address, "N/A")
    flaresolverr       = try(docker_container.flaresolverr.network_data[0].ip_address, "N/A")
  }
}

output "service_endpoints" {
  description = "Local access endpoints for each service"
  value = {
    overseerr    = "http://localhost:${local.media_service_ports.overseerr}"
    sonarr       = "http://localhost:${local.media_service_ports.sonarr}"
    radarr       = "http://localhost:${local.media_service_ports.radarr}"
    prowlarr     = "http://localhost:${local.media_service_ports.prowlarr}"
    flaresolverr = "http://localhost:${local.media_service_ports.flaresolverr}"
  }
}

# ==============================================================================
# Configuration Outputs
# ==============================================================================

output "project_info" {
  description = "Project configuration information"
  value = {
    project_name = var.project_name
    environment  = var.environment
    timezone     = var.timezone
  }
}

output "volume_paths" {
  description = "Volume paths being used"
  value = {
    base_path = local.final_volume_path
    sonarr    = "${local.final_volume_path}/sonarr/config"
    radarr    = "${local.final_volume_path}/radarr/config"
    overseerr = "${local.final_volume_path}/overseerr/config"
    prowlarr  = "${local.final_volume_path}/prowlarr/config"
  }
}

