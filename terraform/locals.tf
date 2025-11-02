locals {
  # Volume path configuration
  final_volume_path = var.volume_path == "" ? path.cwd : var.volume_path

  # Resource naming
  resource_prefix = "${var.project_name}-${var.environment}"
  
  # Common tags for all resources
  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "terraform"
    Timestamp   = timestamp()
  }

  # Docker container configuration
  docker_network_name = "${local.resource_prefix}-network"
  
  # Container restart policy
  restart_policy = var.environment == "prod" ? "always" : "unless-stopped"

  # Twingate resource naming
  twingate_network_name   = "${local.resource_prefix}-remote-network"
  twingate_connector_name = "${local.resource_prefix}-connector"
  
  # Media service ports
  media_service_ports = {
    overseerr    = 5055
    sonarr       = 8989
    radarr       = 7878
    prowlarr     = 9696
    flaresolverr = 8191
  }
}