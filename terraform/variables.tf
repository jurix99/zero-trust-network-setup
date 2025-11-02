variable "account_name" {
  description = "Twingate account name (network subdomain)"
  type        = string
  default     = "julientr99"

  validation {
    condition     = length(var.account_name) > 0 && can(regex("^[a-z0-9-]+$", var.account_name))
    error_message = "Account name must be non-empty and contain only lowercase letters, numbers, and hyphens."
  }
}

variable "api_key" {
  description = "Twingate API key for authentication (sensitive)"
  type        = string
  sensitive   = true

  validation {
    condition     = length(var.api_key) > 20
    error_message = "API key must be at least 20 characters long."
  }
}

variable "group_id" {
  description = "Twingate group ID for access control"
  type        = string

  validation {
    condition     = length(var.group_id) > 0
    error_message = "Group ID must be provided."
  }
}

variable "volume_path" {
  description = "Base path for Docker volumes on the host system. Defaults to current working directory if not specified."
  type        = string
  default     = ""
}

variable "timezone" {
  description = "Timezone for container applications (e.g., 'Europe/Paris', 'America/New_York')"
  type        = string
  default     = "UTC"

  validation {
    condition     = can(regex("^[A-Z][a-z]+/[A-Za-z_]+$", var.timezone)) || var.timezone == "UTC"
    error_message = "Timezone must be a valid IANA timezone (e.g., 'Europe/Paris', 'UTC')."
  }
}

variable "environment" {
  description = "Environment name (e.g., dev, staging, prod)"
  type        = string
  default     = "prod"

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be one of: dev, staging, prod."
  }
}

variable "project_name" {
  description = "Project name for resource naming and tagging"
  type        = string
  default     = "nas-media"

  validation {
    condition     = length(var.project_name) > 0 && length(var.project_name) <= 50
    error_message = "Project name must be between 1 and 50 characters."
  }
}

variable "twingate_connector_log_level" {
  description = "Log level for Twingate connector (0-7, where 7 is most verbose)"
  type        = number
  default     = 3

  validation {
    condition     = var.twingate_connector_log_level >= 0 && var.twingate_connector_log_level <= 7
    error_message = "Log level must be between 0 and 7."
  }
}