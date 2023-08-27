# data "cloudflare_zone" "this" {
#   name = var.zone
# }

# resource "cloudflare_zone" "this" {
#   paused = false
#   plan   = "free"
#   type   = "full"
#   zone   = var.zone
#   account_id = var.account_id
# }

# resource "cloudflare_origin_ca_certificate" "this" {
#   hostnames          = ["*.${var.zone}", var.zone]
#   requested_validity = 0
# }

# Locals block to handle dynamic Cloudflare expression creation
locals {
  # If allowed_countries = ["MY", "SG"], 
  # countries will be ["ip.geoip.country ne \"MY\"", "ip.geoip.country ne \"SG\""]
  countries = [for c in var.allowed_countries : "ip.geoip.country ne \"${c}\""]
  # Eg, "ip.geoip.country ne \"MY\" and ip.geoip.country ne \"SG\""
  # https://developers.cloudflare.com/ruleset-engine/rules-language/
  geoblock_whitelist  = join(" and ", local.countries)
}

# resource "cloudflare_ruleset" "geoblock" {
#   kind    = "zone"
#   name    = "default"
#   phase   = "http_request_firewall_custom"
#   zone_id = var.zone
#   rules {
#     action      = "block"
#     description = "Block Non-MY or SG IP"
#     enabled     = true
#     expression  = local.geoblock_whitelist 
#   }
# }

# module "dns" {
#   source  = "app.terraform.io/ahlooii/dns/cloudflare"
#   version = "2.0.1"

#   zone_id = var.zone
#   default_ttl = 300

#   map_of_records = {
#     "${var.zone}" = [
#       {
#         name    = "syncthing"
#         proxied = true
#       }
#     ]
#   }
# }

resource "cloudflare_record" "debug" {
  name      = "syncthing2"
  value     = "google.com"
  type      = "CNAME"
  zone_id   = var.zone_id
  ttl       = 1
  proxied   = true
}