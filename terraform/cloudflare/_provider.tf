terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "4.13.0"
    }
    bitwarden = {
      source = "maxlaverse/bitwarden"
      version = "0.7.0"
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

provider "bitwarden" {
  server = "https://vault.bitwarden.com"
}