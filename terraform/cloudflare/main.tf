resource "cloudflare_zone" "this" {
  paused = false
  plan   = "free"
  type   = "full"
  zone   = var.zone
}

resource "cloudflare_origin_ca_certificate" "this" {
  hostnames          = ["*.${var.zone}", var.zone]
  requested_validity = 0
}

# Locals block to handle dynamic Cloudflare expression creation
locals {
  # If allowed_countries = ["MY", "SG"], 
  # countries will be ["ip.geoip.country ne \"MY\"", "ip.geoip.country ne \"SG\""]
  countries = [for c in var.allowed_countries : "ip.geoip.country ne \"${c}\""]
  # Eg, "ip.geoip.country ne \"MY\" and ip.geoip.country ne \"SG\""
  geoblock_whitelist  = join(" and ", local.countries)
}

resource "cloudflare_filter" "geoblock" {
  expression = local.geoblock_whitelist
  paused     = false
  zone_id    = cloudflare_zone.this.id
}

resource "cloudflare_firewall_rule" "geoblock" {
  action      = "block"
  description = "Block Non-MY or SG IP"
  filter_id   = cloudflare_filter.geoblock.id
  paused      = false
  zone_id     = cloudflare_zone.this.id
}

module "dns" {
  source  = "app.terraform.io/ahlooii/dns/cloudflare"
  version = "2.0.0"

  zone_id = var.zone
  default_ttl = 300

  map_of_records = {
    "${var.zone}" = [
      {
        name    = "syncthing"
        proxied = true
      }
    ]
  }
}