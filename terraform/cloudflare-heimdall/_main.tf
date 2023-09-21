terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "4.13.0"
    }
  }

  backend "remote" {
    organization = "ahlooii"
    workspaces {
      name = "infrastructure"
    }
  }
}

provider "cloudflare" {
  api_token = var.api_token
}