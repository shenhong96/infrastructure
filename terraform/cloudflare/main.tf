resource "cloudflare_zone" "this" {
  paused = false
  plan   = "free"
  type   = "full"
  zone   = var.zone
}

resource "cloudflare_filter" "geoblock" {
  expression = "(ip.geoip.country ne \"MY\" and ip.geoip.country ne \"SG\")"
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

