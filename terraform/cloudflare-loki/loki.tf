resource "random_id" "loki" {
  byte_length = 32
}

resource "cloudflare_tunnel" "loki" {
  account_id = var.account_id
  name       = var.zone
  secret     = random_id.loki.b64_std
}

resource "cloudflare_tunnel_route" "loki" {
  account_id         = var.account_id
  tunnel_id          = cloudflare_tunnel.loki.id
  network            = "127.0.0.1/32" # Replace with your VPS's IP.
  comment            = "Tunnel route to Loki"
}

resource "cloudflare_access_application" "loki" {
  app_launcher_visible       = true
  auto_redirect_to_identity  = false
  domain                     = var.zone
  enable_binding_cookie      = false
  http_only_cookie_attribute = true
  name                       = var.zone
  self_hosted_domains        = ["${var.zone}"]
  session_duration           = "24h"
  skip_interstitial          = true
  type                       = "self_hosted"
  zone_id                    = var.zone_id
  cors_headers {
    allow_all_headers = true
    allow_all_methods = true
    allow_all_origins = true
  }
}

# resource "cloudflare_tunnel_config" "blog_config" {
#   account_id = var.account_id
#   tunnel_id  = cloudflare_tunnel.loki.id

#   config {
#     warp_routing {
#       enabled = true
#     }
#     origin_request {
#       connect_timeout          = "1m0s"
#       tls_timeout              = "1m0s"
#       tcp_keep_alive           = "1m0s"
#       no_happy_eyeballs        = false
#       keep_alive_connections   = 1024
#       keep_alive_timeout       = "1m0s"
#       http_host_header         = "DOMAIN"
#       origin_server_name       = "DOMAIN_OR_IP" 
#     }
#     ingress_rule {
#       hostname = var.zone
#       service  = ""
#   }
# }
