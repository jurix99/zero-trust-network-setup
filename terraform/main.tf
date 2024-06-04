terraform {
  required_providers {
    twingate = {
      source = "Twingate/twingate"
      version = "3.0.4"
    }
  }
}

provider "twingate" {
  network   = "Julientr99"
  api_token = "var.api_key"
}