terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "4.13.0"
    }
    random = {}
  }

  backend "remote" {
    organization = "ahlooii"
    workspaces {
      name = "loki"
    }
  }
}

provider "cloudflare" {
  api_token = var.api_token
}