variable "api_token" {
  description = "Api token that has access to run the terraform towards Cloudflare"
  type        = string
}

variable "zone" {
  description = "The zone where resources will be created"
  type        = string
}

