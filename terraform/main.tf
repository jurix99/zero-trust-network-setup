terraform {
  required_providers {
    twingate = {
      source = "Twingate/twingate"
      version = "3.0.4"
    }
    docker = {
      source = "kreuzwerker/docker"
    }
  }
}

provider "twingate" {
  network   = "${var.account_name}"
  api_token = "${var.api_key}"
}

provider "docker" {}