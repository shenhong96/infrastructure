# Locals block to handle dynamic Cloudflare expression creation
locals {
  # If allowed_countries = ["MY", "SG"], 
  # countries will be ["ip.geoip.country ne \"MY\"", "ip.geoip.country ne \"SG\""]
  countries = [for c in var.allowed_countries : "ip.geoip.country ne \"${c}\""]
  # Eg, "ip.geoip.country ne \"MY\" and ip.geoip.country ne \"SG\""
  # https://developers.cloudflare.com/ruleset-engine/rules-language/
  geoblock_whitelist = "(${join(" and ", local.countries)})"
}

resource "cloudflare_ruleset" "geoblock" {
  kind    = "zone"
  name    = "default"
  phase   = "http_request_firewall_custom"
  zone_id = var.zone_id
  rules {
    action      = "block"
    description = "Blocking countries that are not in the whitelist."
    enabled     = true
    expression  = local.geoblock_whitelist 
  }
}

module "dns" {
  source  = "app.terraform.io/ahlooii/dns/cloudflare"
  version = "2.0.3"

  zone_id     = var.zone_id
  default_ttl = 300

  map_of_records = {
    "${var.primary}" = [{
        name    = "@"
        proxied = true
    }],
    "${var.zone}" = [
      {
        name    = "jellyfin"
        proxied = true
      },
      {
        name    = "auth"
        proxied = true
      },
      {
        name    = "librespeed"
        proxied = true
      },
      {
        name    = "wireguard"
        proxied = true
      },
      {
        name    = "syncthing"
        proxied = true
      },
      {
        name    = "nextcloud"
        proxied = true
      }
    ],

    "${var.email_route}" = [
      {
        name    = "mail"
        proxied = false
      },
      {
        name    = "webmail"
        proxied = false
      },
      {
        name     = var.zone
        proxied  = false
        priority = 10
        type     = "MX"
      }
    ],

    "${var.email_relay_route}" = [
      {
        name     = var.zone
        proxied  = false
        priority = 20
        type     = "MX"
      }
    ],
    "${var.spf_record}" = [
      {
        name    = var.zone
        proxied = false
        type    = "TXT"
      }
    ],
    "${var.dkim_record}" = [
      {
        name    = "x._domainkey"
        proxied = false
        type    = "TXT"
      }
    ],

    "${var.oracle_instance}" = [
      {
        name    = "*.oracle"
        proxied = false
        type    = "A"
      }
    ]
  }
}

# resource "cloudflare_access_application" "kasm" {
#   app_launcher_visible       = true
#   auto_redirect_to_identity  = false
#   domain                     = "kasm.${var.zone}"
#   enable_binding_cookie      = false
#   http_only_cookie_attribute = true
#   name                       = "kasm"
#   self_hosted_domains        = ["kasm.${var.zone}"]
#   session_duration           = "24h"
#   skip_interstitial          = true
#   type                       = "self_hosted"
#   zone_id                    = var.zone_id
#   cors_headers {
#     allow_all_headers = true
#     allow_all_methods = true
#     allow_all_origins = true
#   }
# }