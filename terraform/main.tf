terraform {
  required_version = ">= 1.5.0"

  required_providers {
    twingate = {
      source  = "Twingate/twingate"
      version = "~> 3.0"
    }
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

provider "twingate" {
  network   = var.account_name
  api_token = var.api_key
}

provider "docker" {
  host = "unix:///var/run/docker.sock"
}