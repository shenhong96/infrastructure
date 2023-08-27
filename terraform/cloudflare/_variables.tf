variable "api_token" {
  description = "Api token that has access to run the terraform towards Cloudflare"
  type        = string
}

variable "account_id" {
  description = "Account id, retrieve from Cloudflare Dashboard"
  type        = string
}

variable "zone" {
  description = "The zone where resources will be created"
  type        = string
}

variable "zone_id" {
  description = "The zone where resources will be created"
  type        = string
}

variable "allowed_countries" {
  description = "Country that'll be excluded in the Geoblock Filters"
  type        = list(string)
  default     = ["MY", "SG"]
}
